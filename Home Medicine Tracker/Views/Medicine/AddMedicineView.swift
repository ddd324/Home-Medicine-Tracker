//
//  AddMedicineView.swift
//  Home Medicine Tracker
//
//  Created by Djy on 21/09/2026.
//

import SwiftUI

struct AddMedicineView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var medicineViewModel: MedicineViewModel
    
    @State private var name = ""
    @State private var category = ""
    @State private var expiryDate = Date()
    @State private var notes = ""
    @State private var selectedLocationID: UUID?
    
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
                    TextField("Category", text: $category)
                    DatePicker("Expiry Date", selection: $expiryDate, displayedComponents: .date)
                    if let preselectedLocation {
                        LabeledContent(
                            "Storage Location",
                            value: preselectedLocation.name
                        )
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
                        let medicine = Medicine(id: UUID(), name: name, category: category, expiryDate: expiryDate, notes: notes.isEmpty ? nil : notes, photoData: nil, reminderEnabled: false, status: "active", createdAt: Date(), returnedDate: nil, storageLocation: selectedStorageLocation)
                        
                        if medicineViewModel.addMedicine(medicine) {
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
