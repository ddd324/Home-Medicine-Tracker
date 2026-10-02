//
//  StorageLocationDetailView.swift
//  Home Medicine Tracker
//
//  Created by Djy on 22/09/2026.
//

import SwiftUI

struct StorageLocationDetailView: View {
    
    @ObservedObject var storageLocationViewModel: StorageLocationViewModel
    
    @State private var location: StorageLocation
    @State private var showingAddMedicine = false
    
    @StateObject private var storageLocationDetailViewModel: StorageLocationDetailViewModel
    @StateObject private var medicineViewModel: MedicineViewModel
    
    init(storageLocationViewModel: StorageLocationViewModel, location: StorageLocation, medicineRepository: MedicineRepository) {
        self.storageLocationViewModel = storageLocationViewModel
        _location = State(initialValue: location)
        
        let getMedicinesByStorageLocationUseCase = GetMedicinesByStorageLocationUseCase(repository: medicineRepository)
        
        _storageLocationDetailViewModel = StateObject(wrappedValue: StorageLocationDetailViewModel(getMedicinesByStorageLocationUseCase: getMedicinesByStorageLocationUseCase))
        
        let getMedicinesUseCase = GetMedicinesUseCase(repository: medicineRepository)
        let addMedicineUseCase = AddMedicineUseCase(repository: medicineRepository)
        let updateMedicineUseCase = UpdateMedicineUseCase(repository: medicineRepository)
        let markMedicineAsReturnedUseCase = MarkMedicineAsReturnedUseCase(repository: medicineRepository)
        
        _medicineViewModel = StateObject(wrappedValue: MedicineViewModel(getMedicinesUseCase: getMedicinesUseCase, addMedicineUseCase: addMedicineUseCase, updateMedicineUseCase: updateMedicineUseCase, markMedicineAsReturnedUseCase: markMedicineAsReturnedUseCase))
    }
    
    private func statusColor(for medicine: Medicine) -> Color {
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
            Section("Location Information") {
                LabeledContent {
                    Text(location.name)
                        .foregroundStyle(.secondary)
                } label: {
                    Label("Location Name", systemImage: "cabinet.fill")
                        .foregroundStyle(Color("Primary"))
                }

                if let room = location.room, !room.isEmpty {
                    LabeledContent {
                        Text(room)
                            .foregroundStyle(.secondary)
                    } label: {
                        Label("Room", systemImage: "house.fill")
                            .foregroundStyle(Color("Primary"))
                    }
                }

                if let notes = location.notes, !notes.isEmpty {
                    LabeledContent {
                        Text(notes)
                            .foregroundStyle(.secondary)
                    } label: {
                        Label("Notes", systemImage: "note.text")
                            .foregroundStyle(Color("Primary"))
                    }
                }
            }

            Section("Medicines") {
                if storageLocationDetailViewModel.medicines.isEmpty {
                    Text("No medicines in this location.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(storageLocationDetailViewModel.medicines) { medicine in
                        NavigationLink {
                            MedicineDetailView(medicine: medicine, medicineViewModel: medicineViewModel)
                        } label: {
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Text(medicine.name)
                                        .font(.headline)

                                    Spacer()

                                    Text(medicine.displayStatus)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(statusColor(for: medicine))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
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
                                
                                Text("Expires " + medicine.expiryDate.formatted(date: .abbreviated, time: .omitted))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }

            Section {
                Button {
                    showingAddMedicine = true
                } label: {
                    Label("Add Medicine Here", systemImage: "plus.circle.fill")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("Primary"))
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color("Background"))
        .navigationTitle(location.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink("Edit") {
                    EditStorageLocationView(location: location, storageLocationViewModel: storageLocationViewModel) { updatedLocation in
                        location = updatedLocation
                    }
                }
            }
        }
        .task {
            storageLocationDetailViewModel.loadMedicines(
                storageLocationID: location.id
            )
        }
        .onAppear {
            storageLocationDetailViewModel.loadMedicines(
                storageLocationID: location.id
            )
        }
        .sheet(isPresented: $showingAddMedicine, onDismiss: {
            storageLocationDetailViewModel.loadMedicines(storageLocationID: location.id)
        }) {
            AddMedicineView(medicineViewModel: medicineViewModel, preselectedLocation: location)
        }
    }
}

