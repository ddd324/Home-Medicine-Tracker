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
    
    @State private var name: String
    @State private var category: String
    @State private var expriyDate: Date
    @State private var notes: String
    
    init(medicine: Medicine, medicineViewModel: MedicineViewModel) {
        self.medicine = medicine
        self.medicineViewModel = medicineViewModel
        
        _name = State(initialValue: medicine.name)
        _category = State(initialValue: medicine.category)
        _expriyDate = State(initialValue: medicine.expiryDate)
        _notes = State(initialValue: medicine.notes ?? "")
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Medicine Name", text: $name)
                TextField("Category", text: $category)
                DatePicker("Expiry Date", selection: $expriyDate, displayedComponents: .date)
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
                    updatedMedicine.expiryDate = expriyDate
                    updatedMedicine.notes = notes.isEmpty ? nil : notes
                    
                    if medicineViewModel.updateMedicine(updatedMedicine) {
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


