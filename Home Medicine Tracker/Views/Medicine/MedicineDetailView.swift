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
    
    private var statusColor: Color {
        switch medicine.displayStatus {
        case "Expired":
            return .red
        case "Expiring":
            return .orange
        case "Returned":
            return .gray
        default:
            return .green
        }
    }
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(medicine.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text(medicine.displayStatus)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(statusColor)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 5)
                            .background(
                                medicine.displayStatus == "Expired"
                                    ? Color("Coral")
                                    : medicine.displayStatus == "Expiring"
                                    ? Color("Peach")
                                    : Color("Mint")
                            )
                            .clipShape(Capsule())
                    }
                    
                    if !medicine.category.isEmpty {
                        Text(medicine.category)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    if let photoData = medicine.photoData,
                       let uiImage = UIImage(data: photoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 220)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: .black.opacity(0.06), radius: 10, y: 4)
                    } else {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("Lavender"))
                            .frame(height: 220)
                            .overlay {
                                Image(systemName: "pills.fill")
                                    .font(.system(size: 70))
                                    .foregroundStyle(.white)
                            }
                    }
                }
                .padding(.vertical, 6)
            }
            .listRowBackground(Color("Card"))
            
            Section("Medicine Information") {
                LabeledContent {
                    Text(medicine.expiryDate, style: .date)
                } label: {
                    Label("Expiry Date", systemImage: "calendar")
                        .foregroundStyle(Color("Primary"))
                }
                LabeledContent {
                    Text(medicine.storageLocation?.name ?? "Not set")
                } label: {
                    Label("Storage Location",systemImage: "archivebox")
                        .foregroundStyle(Color("Primary"))
                }
                LabeledContent {
                    Text(medicine.category)
                } label: {
                    Label("Category",systemImage: "square.grid.2x2")
                        .foregroundStyle(Color("Primary"))
                }
                LabeledContent {
                    Text(medicine.reminderEnabled ? "Enabled" : "Disabled")
                } label: {
                    Label("Reminder",systemImage: "bell")
                        .foregroundStyle(Color("Primary"))
                }
                
                if let notes = medicine.notes, !notes.isEmpty {
                    LabeledContent {
                        Text(notes)
                    } label: {
                        Label("Notes",systemImage: "note.text")
                    }
                }
            }
            
            Section("Disposal & Return") {
                NavigationLink {
                    NatRUMInformationView()
                } label: {
                    Text("NatRUM Information")
                        .foregroundStyle(.green)
                }
                if medicine.status != "returned" {
                    Button("Mark as Returned", role: .destructive) {
                        showingReturnConfirmation = true
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color("Background"))
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
                    MedicineNotificationManager.shared.cancelExpiryNotifications(for: medicine)
                    
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

