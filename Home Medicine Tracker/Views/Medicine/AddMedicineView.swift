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
    @State private var selectedLocation = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Medicine Name", text: $name)
                    TextField("Category", text: $category)
                    DatePicker("Expiry Date", selection: $expiryDate, displayedComponents: .date)
                    TextField("Storage Location",text: $selectedLocation)
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
                        let medicine = Medicine(id: UUID(), name: name, category: category, expiryDate: expiryDate, notes: notes.isEmpty ? nil : notes, photoData: nil, reminderEnabled: false, status: "active", createdAt: Date(), returnedDate: nil, storageLocation: nil)
                        
                        do {
                            try medicineViewModel.addMedicine(medicine)
                            dismiss()
                        } catch {
                            print("Failed to add medicine: \(error)")
                        }
                    }
                }
            }
        }
    }
}


