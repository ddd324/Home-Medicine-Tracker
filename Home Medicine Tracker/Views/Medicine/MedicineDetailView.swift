//
//  MedicineDetailView.swift
//  Home Medicine Tracker
//
//  Created by Djy on 21/09/2026.
//

import SwiftUI

struct MedicineDetailView: View {
    
    let medicine: Medicine
    
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
                Button("NatRUM Information") {
                    
                }
                Button("Mark as Returned", role: .destructive) {
                    
                }
            }
        }
        .navigationTitle(medicine.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    
                }
            }
        }
    }
}

