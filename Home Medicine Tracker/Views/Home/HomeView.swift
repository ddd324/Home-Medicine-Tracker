//
//  HomeView.swift
//  Home Medicine Tracker
//
//  Created by Djy on 23/09/2026.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var expiryViewModel: ExpiryViewModel
    @StateObject private var medicineViewModel: MedicineViewModel
    @State private var showingExpiringSoon = false
    @State private var showingExpired = false
    @State private var showingMedicines = false
    
    private let medicineRepository: MedicineRepository
    private let storageLocationRepository: StorageLocationRepository
    
    init(medicineRepository: MedicineRepository, storageLocationRepository: StorageLocationRepository) {
        self.medicineRepository = medicineRepository
        self.storageLocationRepository = storageLocationRepository
        
        let getExpiryingMedicinesUseCase = GetExpiringMedicinesUseCase(repository: medicineRepository)
        let getExpiredMedicinesUseCase = GetExpiredMedicinesUseCase(repository: medicineRepository)
        
        _expiryViewModel = StateObject(wrappedValue: ExpiryViewModel (getExpiringMedicinesUseCase: getExpiryingMedicinesUseCase, getExpiredMedicinesUseCase: getExpiredMedicinesUseCase))
        
        let getMedicinesUseCase = GetMedicinesUseCase(repository: medicineRepository)
        let addMedicineUseCase = AddMedicineUseCase(repository: medicineRepository)
        let updateMedicineUseCase = UpdateMedicineUseCase(repository: medicineRepository)
        let markMedicineAsReturnedUseCase = MarkMedicineAsReturnedUseCase(repository: medicineRepository)
        
        _medicineViewModel = StateObject(wrappedValue: MedicineViewModel(getMedicinesUseCase: getMedicinesUseCase, addMedicineUseCase: addMedicineUseCase, updateMedicineUseCase: updateMedicineUseCase, markMedicineAsReturnedUseCase: markMedicineAsReturnedUseCase))
        
    }
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Welcome to Home Medicine Tracker")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text("Keep track of your household medicines, expiry dates, and storage locations.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                
                Section {
                    VStack(spacing: 12) {
                        Button {
                            showingMedicines = true
                        } label: {
                            VStack(spacing: 6) {
                                Text("\(medicineViewModel.medicines.count)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                Text("Medicines")
                                    .font(.subheadline)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 90)
                            .background(Color.blue.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .buttonStyle(.plain)

                        HStack(spacing: 12) {
                            Button {
                                showingExpiringSoon = true
                            } label: {
                                VStack(spacing: 6) {
                                    Text("\(expiryViewModel.expiringMedicines.count)")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    Text("Expiring Soon")
                                        .font(.subheadline)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 90)
                                .background(Color.orange.opacity(0.10))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                            .buttonStyle(.plain)

                            Button {
                                showingExpired = true
                            } label: {
                                VStack(spacing: 6) {
                                    Text("\(expiryViewModel.expiredMedicines.count)")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    Text("Expired")
                                        .font(.subheadline)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 90)
                                .background(Color.red.opacity(0.10))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                Section("Medicine Tip") {
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "info.circle.fill")
                            .foregroundStyle(.blue)

                        Text("Check expiry dates regularly and return expired or unwanted medicines to a participating community pharmacy through the NatRUM Program.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle("Home")
            .task {
                expiryViewModel.loadExpiryMedicines()
                medicineViewModel.loadMedicines()
            }
            .onAppear {
                expiryViewModel.loadExpiryMedicines()
                medicineViewModel.loadMedicines()
            }
            .navigationDestination(isPresented: $showingMedicines) {
                MedicineListView(repository: medicineRepository, storageLocationRepository: storageLocationRepository)
            }
            .navigationDestination(isPresented: $showingExpiringSoon) {
                ExpiringSoonView(repository: medicineRepository)
            }
            .navigationDestination(isPresented: $showingExpired) {
                ExpiredMedicinesView(repository: medicineRepository)
            }
        }
    }
}

