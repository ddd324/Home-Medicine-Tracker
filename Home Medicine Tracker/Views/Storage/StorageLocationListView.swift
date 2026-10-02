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
                            HStack(spacing: 14) {
                                Image(systemName: "cabinet.fill")
                                    .font(.title2)
                                    .foregroundStyle(Color("Primary"))
                                    .frame(width: 50, height: 50)
                                    .background(Color("SkyBlue"))
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(location.name)
                                        .font(.headline)

                                    if let room = location.room, !room.isEmpty {
                                        Text(room)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                }

                                Spacer()

                                VStack(spacing: 2) {
                                    Text("\(storageLocationViewModel.medicineCount(for: location.id))")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    Text(
                                        storageLocationViewModel.medicineCount(for: location.id) == 1
                                        ? "medicine"
                                        : "medicines"
                                    )
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 10)
                        }
                        .listRowBackground(Color("Card"))
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                    .background(Color("Background"))
                }
            }
            .navigationTitle("Storage Locations")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddLocation = true
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color("Primary"))
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
