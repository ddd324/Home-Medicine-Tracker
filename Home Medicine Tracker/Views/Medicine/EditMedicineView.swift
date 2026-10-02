//
//  EditMedicineView.swift
//  Home Medicine Tracker
//
//  Created by Djy on 21/09/2026.
//

import SwiftUI
import PhotosUI

struct EditMedicineView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var medicineViewModel: MedicineViewModel
    
    let medicine: Medicine
    let onSave: (Medicine) -> Void
    
    @State private var name: String
    @State private var category: String
    @State private var expiryDate: Date
    @State private var notes: String
    @State private var showingNewCategoryField = false
    @State private var newCategory = ""
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var photoData: Data?
    @State private var reminderEnabled: Bool
    
    init(medicine: Medicine, medicineViewModel: MedicineViewModel, onSave: @escaping (Medicine) -> Void) {
        self.medicine = medicine
        self.medicineViewModel = medicineViewModel
        self.onSave = onSave
        
        _name = State(initialValue: medicine.name)
        _category = State(initialValue: medicine.category)
        _expiryDate = State(initialValue: medicine.expiryDate)
        _notes = State(initialValue: medicine.notes ?? "")
        _photoData = State(initialValue: medicine.photoData)
        _reminderEnabled = State(initialValue: medicine.reminderEnabled)
    }
    
    var body: some View {
        Form {
            Section {
                
                if let photoData,
                   let uiImage = UIImage(data: photoData) {
                    
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                } else {
                    
                    PhotosPicker(
                        selection: $selectedPhotoItem,
                        matching: .images
                    ) {
                        VStack(spacing: 10) {
                            
                            Image(systemName: "camera.fill")
                                .font(.title2)
                                .foregroundStyle(Color("Primary"))
                                .frame(width: 46, height: 46)
                                .background(Color("Lavender"))
                                .clipShape(Circle())
                            
                            Text("Add Photo")
                                .foregroundStyle(Color("Primary"))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 110)
                    }
                }
                
                if photoData != nil {
                    PhotosPicker(
                        selection: $selectedPhotoItem,
                        matching: .images
                    ) {
                        Label("Change Photo", systemImage: "photo")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .onChange(of: selectedPhotoItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        photoData = data
                    }
                }
            }
            Section {
                
                TextField("Medicine Name", text: $name)
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
            }
            
            Section {
                DatePicker("Expiry Date", selection: $expiryDate, displayedComponents: .date)
                Toggle("Expiry Reminder", isOn: $reminderEnabled)
                    .tint(Color("Primary"))
                LabeledContent("Storage Location", value: medicine.storageLocation?.name ?? "Not set")
            }
            
            Section {
                TextField("Notes", text: $notes, axis: .vertical)
                    .lineLimit(3...5)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color("Background"))
        .navigationTitle("Edit Medicine")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    var updatedMedicine = medicine
                    updatedMedicine.name = name
                    updatedMedicine.category = category
                    updatedMedicine.expiryDate = expiryDate
                    updatedMedicine.notes = notes.isEmpty ? nil : notes
                    updatedMedicine.photoData = photoData
                    updatedMedicine.reminderEnabled = reminderEnabled
                    
                    if medicineViewModel.updateMedicine(updatedMedicine) {
                        MedicineNotificationManager.shared.cancelExpiryNotifications(for: medicine)
                        
                        if reminderEnabled {
                            Task {
                                let granted = await MedicineNotificationManager.shared.requestPermission()
                                
                                if granted {
                                    await MedicineNotificationManager.shared.scheduleExpiryNotification(for: updatedMedicine)
                                }
                            }
                        }
                        onSave(updatedMedicine)
                        dismiss()
                    }
                }
            }
        }
        .alert(
            "Unable to Update Medicine",
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


