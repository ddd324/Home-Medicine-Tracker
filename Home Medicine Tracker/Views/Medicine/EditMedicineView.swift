//
//  EditMedicineView.swift
//  Home Medicine Tracker
//
//  Created by Djy on 21/09/2026.
//

import SwiftUI

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
    
    init(medicine: Medicine, medicineViewModel: MedicineViewModel, onSave: @escaping (Medicine) -> Void) {
        self.medicine = medicine
        self.medicineViewModel = medicineViewModel
        self.onSave = onSave
        
        _name = State(initialValue: medicine.name)
        _category = State(initialValue: medicine.category)
        _expiryDate = State(initialValue: medicine.expiryDate)
        _notes = State(initialValue: medicine.notes ?? "")
    }
    
    var body: some View {
        Form {
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
                
                DatePicker("Expiry Date", selection: $expiryDate, displayedComponents: .date)
                LabeledContent("Storage Location", value: medicine.storageLocation?.name ?? "Not set")
                TextField("Notes", text: $notes, axis: .vertical)
                    .lineLimit(3...5)
            }
        }
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
                    
                    if medicineViewModel.updateMedicine(updatedMedicine) {
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


