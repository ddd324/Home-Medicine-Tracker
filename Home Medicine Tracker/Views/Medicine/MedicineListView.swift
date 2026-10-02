//
//  MedicineListView.swift
//  Home Medicine Tracker
//
//  Created by Djy on 21/09/2026.
//

import SwiftUI

struct MedicineListView: View {
    
    @State private var showingAddMedicine = false
    @State private var storageLocations: [StorageLocation] = []
    @StateObject private var medicineViewModel: MedicineViewModel
    
    private let storageLocationRepository: StorageLocationRepository
    private let getStorageLocationsUseCase: GetStorageLocationsUseCase
    
    init(repository: MedicineRepository, storageLocationRepository: StorageLocationRepository) {
        self.storageLocationRepository = storageLocationRepository
        self.getStorageLocationsUseCase = GetStorageLocationsUseCase(repository: storageLocationRepository)
        let getMedicinesUseCase = GetMedicinesUseCase(repository: repository)
        let addMedicineUseCase = AddMedicineUseCase(repository: repository)
        let updateMedicineUseCase = UpdateMedicineUseCase(repository: repository)
        let markMedicineAsReturnedUseCase = MarkMedicineAsReturnedUseCase(repository: repository)
        
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
        NavigationStack {
            Group {
                if medicineViewModel.medicines.isEmpty {
                    ContentUnavailableView("No Medicines", systemImage: "cross.case", description: Text("Add your first medicine to start tracking its expiry date."))
                } else {
                    VStack(spacing: 0) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.secondary)

                            TextField("Search Medicines", text: $medicineViewModel.searchText)

                            if !medicineViewModel.searchText.isEmpty {
                                Button {
                                    medicineViewModel.searchText = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                        .frame(height: 44)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .padding(.horizontal)
                        .padding(.top)
                        
                        Picker("Filter", selection: $medicineViewModel.selectedFilter) {
                            ForEach(MedicineFilter.allCases) { filter in
                                Text(filter.rawValue)
                                    .tag(filter)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding()
                        
                        List(medicineViewModel.filteredMedicines) { medicine in
                            NavigationLink {
                                MedicineDetailView(medicine: medicine, medicineViewModel: medicineViewModel)
                            } label: {
                                HStack(alignment: .top, spacing: 12) {
                                    if let photoData = medicine.photoData, let uiImage = UIImage(data: photoData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 76, height: 76)
                                            .clipShape(RoundedRectangle(cornerRadius: 18))
                                            .clipped()
                                    } else {
                                        Image(systemName: "pills.fill")
                                            .font(.title2)
                                            .foregroundStyle(.secondary)
                                            .frame(width: 76, height: 76)
                                            .background(Color("Lavender"))
                                            .clipShape(RoundedRectangle(cornerRadius: 18))
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack(alignment: .top) {
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
                                        
                                        if let location = medicine.storageLocation {
                                            Text(location.name)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                }
                                .padding(.vertical, 4)
                                .background(Color("Card"))
                            }
                        }
                    }
                }
            }
            .navigationTitle("My Medicines")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddMedicine = true
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color("Primary"))
                    }
                }
            }
            .task {
                medicineViewModel.loadMedicines()
                
                do {
                    storageLocations = try getStorageLocationsUseCase.execute()
                } catch {
                    print("Failed to load storage locations: \(error)")
                }
            }
        }
        .sheet(isPresented: $showingAddMedicine) {
            AddMedicineView(medicineViewModel: medicineViewModel, storageLocations: storageLocations)
        }
    }
}

#Preview {
    MedicineListView(
        repository: JSONMedicineRepository(),
        storageLocationRepository: JSONStorageLocationRepository()
    )
}
