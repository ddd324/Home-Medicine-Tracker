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

    var body: some View {
        List {
            Section("Location Information") {
                LabeledContent("Location Name", value: location.name)

                if let room = location.room,
                   !room.isEmpty {
                    LabeledContent("Room", value: room)
                }

                if let notes = location.notes,
                   !notes.isEmpty {
                    LabeledContent("Notes", value: notes)
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
                                Text(medicine.name)
                                    .font(.headline)
                                Text("Expires \(medicine.expiryDate.formatted(date: .abbreviated, time: .omitted))")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }

            Section {
                Button("Add Medicine Here") {
                    showingAddMedicine = true
                }
            }
        }
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

