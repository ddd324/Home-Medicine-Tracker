//
//  AddMedicineView.swift
//  Home Medicine Tracker
//
//  Created by Djy on 21/09/2026.
//

import SwiftUI
import PhotosUI

struct AddMedicineView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var medicineViewModel: MedicineViewModel
    
    @State private var name = ""
    @State private var category = ""
    @State private var expiryDate = Date()
    @State private var notes = ""
    @State private var selectedLocationID: UUID?
    @State private var showingNewCategoryField = false
    @State private var newCategory = ""
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var photoData: Data?
    @State private var reminderEnabled = false
    
    let preselectedLocation: StorageLocation?
    let storageLocations: [StorageLocation]
    
    init(medicineViewModel: MedicineViewModel, storageLocations: [StorageLocation] = [], preselectedLocation: StorageLocation? = nil) {
        self.medicineViewModel = medicineViewModel
        self.storageLocations = storageLocations
        self.preselectedLocation = preselectedLocation
        
        _selectedLocationID = State(initialValue: preselectedLocation?.id)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Medicine Name", text: $name)
                    
                    if let photoData,
                       let uiImage = UIImage(data: photoData) {
                        
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    PhotosPicker(
                        selection: $selectedPhotoItem,
                        matching: .images
                    ) {
                        Label(
                            photoData == nil ? "Add Photo" : "Change Photo",
                            systemImage: "photo"
                        )
                    }
                    .onChange(of: selectedPhotoItem) { _, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                photoData = data
                            }
                        }
                    }

                    Picker("Category", selection: $category) {
                        Text("Select Category")
                            .tag("")

                        ForEach(medicineViewModel.availableCategories, id: \.self) { categoryName in
                            Text(categoryName)
                                .tag(categoryName)
                        }

                        if !category.isEmpty &&
                            !medicineViewModel.availableCategories.contains(category) {
                            Text(category)
                                .tag(category)
                        }
                    }

                    Button("Add New Category") {
                        showingNewCategoryField = true
                    }

                    if showingNewCategoryField {
                        TextField("New Category", text: $newCategory)

                        Button("Use This Category") {
                            let trimmedCategory = newCategory
                                .trimmingCharacters(in: .whitespacesAndNewlines)

                            if !trimmedCategory.isEmpty {
                                category = trimmedCategory
                                newCategory = ""
                                showingNewCategoryField = false
                            }
                        }
                    }
                    DatePicker("Expiry Date", selection: $expiryDate, displayedComponents: .date)
                    Toggle("Expiry Reminder", isOn: $reminderEnabled)
                    if let preselectedLocation {
                        LabeledContent("Storage Location", value: preselectedLocation.name)
                    } else {
                        Picker("Storage Location", selection: $selectedLocationID) {
                            Text("None")
                                .tag(nil as UUID?)

                            ForEach(storageLocations) { location in
                                Text(location.name)
                                    .tag(location.id as UUID?)
                            }
                        }
                    }
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...5)
                }
            }
            .navigationTitle("Add Medicine")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let selectedStorageLocation = preselectedLocation ?? storageLocations.first {
                            $0.id == selectedLocationID
                        }
                        let medicine = Medicine(id: UUID(), name: name, category: category, expiryDate: expiryDate, notes: notes.isEmpty ? nil : notes, photoData: photoData, reminderEnabled: reminderEnabled, status: "active", createdAt: Date(), returnedDate: nil, storageLocation: selectedStorageLocation)
                        
                        if medicineViewModel.addMedicine(medicine) {
                            if reminderEnabled {
                                Task {
                                    let granted = await MedicineNotificationManager.shared.requestPermission()
                                    
                                    if granted {
                                        await MedicineNotificationManager.shared.scheduleExpiryNotification(for: medicine)
                                        
                                        await MedicineNotificationManager.shared
                                            .scheduleTestNotification(for: medicine)
                                        
                                        try? await Task.sleep(for: .seconds(10))

                                        await MedicineNotificationManager.shared
                                            .printNotificationStatus()
                                    }
                                }
                            }
                            dismiss()
                        }
                    }
                }
            }
        }
        .alert(
            "Unable to Add Medicine",
            isPresented: Binding(
                get: { medicineViewModel.errorMessage != nil },
                set: { newValue in
                    if !newValue {
                        medicineViewModel.errorMessage = nil
                    }
                }
            )
        ) {
            Button("OK", role: .cancel) {
                medicineViewModel.errorMessage = nil
            }
        } message: {
            Text(medicineViewModel.errorMessage ?? "")
        }
    }
}
