//
//  StorageLocationListView.swift
//  Home Medicine Tracker
//
//  Created by Djy on 22/09/2026.
//

import SwiftUI

struct StorageLocationListView: View {
    
    @StateObject private var storageLocationViewModel: StorageLocationViewModel
    @State private var showingAddLocation = false
    
    private let medicineRepository: MedicineRepository
    
    init(medicineRepository: MedicineRepository, storageLocationRepository: StorageLocationRepository) {
        self.medicineRepository = medicineRepository
        let getStorageLocationUseCase = GetStorageLocationsUseCase(repository: storageLocationRepository)
        let addStorageLocationUseCase = AddStorageLocationUseCase(repository: storageLocationRepository)
        let updateStorageLocationUseCase = UpdateStorageLocationUseCase(storageLocationRepository: storageLocationRepository, medicineRepository: medicineRepository)
        let getMedicinesByStorageLocationUseCase = GetMedicinesByStorageLocationUseCase(repository: medicineRepository)
        
        _storageLocationViewModel = StateObject(wrappedValue: StorageLocationViewModel(getStorageLocationsUseCase: getStorageLocationUseCase, addStorageLocationUseCase: addStorageLocationUseCase, updateStorageLocationUseCase: updateStorageLocationUseCase, getMedicinesByStorageLocationUseCase: getMedicinesByStorageLocationUseCase))
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if storageLocationViewModel.storageLocations.isEmpty {
                    ContentUnavailableView("No Storage Locations", systemImage: "cabinet", description: Text("Add a location to organise your medicines."))
                } else {
                    List(storageLocationViewModel.storageLocations) { location in
                        NavigationLink {
                            StorageLocationDetailView(storageLocationViewModel: storageLocationViewModel, location: location, medicineRepository: medicineRepository)
                        } label: {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(location.name)
                                    .font(.headline)
                                
                                if let room = location.room, !room.isEmpty {
                                    Text(room)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Text("\(storageLocationViewModel.medicineCount(for: location.id))" + (storageLocationViewModel.medicineCount(for: location.id) == 1 ? "medicine" : "medicines"))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Storage Locations")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddLocation = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .task {
                storageLocationViewModel.loadStorageLocations()
                storageLocationViewModel.loadMedicineCounts()
            }
            .onAppear {
                storageLocationViewModel.loadStorageLocations()
                storageLocationViewModel.loadMedicineCounts()
            }
        }
        .sheet(isPresented: $showingAddLocation) {
            AddStorageLocationView(
                storageLocationViewModel: storageLocationViewModel
            )
        }
    }
}

#Preview {
    StorageLocationListView(
        medicineRepository: JSONMedicineRepository(),
        storageLocationRepository: JSONStorageLocationRepository()
    )
}
