//
//  MedicineDetailView.swift
//  Home Medicine Tracker
//
//  Created by Djy on 21/09/2026.
//

import SwiftUI

struct MedicineDetailView: View {
    
    @State private var medicine: Medicine
    @State private var showingReturnConfirmation = false
    
    @Environment(\.openURL) private var openURL
    
    init(medicine: Medicine, medicineViewModel: MedicineViewModel) {
        _medicine = State(initialValue: medicine)
        self.medicineViewModel = medicineViewModel
    }
    
    @ObservedObject var medicineViewModel: MedicineViewModel
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Text(medicine.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(medicine.status.capitalized)
                        .font(.subheadline)
                }
            }
            
            Section("Medicine Information") {
                LabeledContent("Expiry Date") {
                    Text(medicine.expiryDate, style: .date)
                }
                LabeledContent("Storage Location", value: medicine.storageLocation?.name ?? "Not set")
                LabeledContent("Category", value: medicine.category)
                LabeledContent("Reminder", value: medicine.reminderEnabled ? "Enabled" : "Disabled")
                
                if let notes = medicine.notes, !notes.isEmpty {
                    LabeledContent("Notes", value: notes)
                }
            }
            
            Section("Disposal & Return") {
                NavigationLink {
                    NatRUMInformationView()
                } label: {
                    Text("NatRUM Information")
                }
                if medicine.status != "returned" {
                    Button("Mark as Returned", role: .destructive) {
                        showingReturnConfirmation = true
                    }
                }
            }
        }
        .navigationTitle(medicine.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink("Edit") {
                    EditMedicineView(medicine: medicine, medicineViewModel: medicineViewModel) { updatedMedicine in
                        medicine = updatedMedicine
                    }
                }
            }
        }
        .alert("Mark as Returned?", isPresented: $showingReturnConfirmation) {
            Button("Confirm Return", role: .destructive) {
                if medicineViewModel.markMedicineAsReturned(medicine) {
                    medicine.status = "returned"
                    medicine.returnedDate = Date()
                }
            }
            
            Button("Cancel", role: .cancel) {
                
            }
        } message: {
            Text("This medicine will be marked as returned and removed from the active medicine inventory.")
        }
    }
}

