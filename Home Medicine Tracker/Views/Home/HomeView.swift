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
                    VStack(alignment: .leading) {
                        Text("Welcome back 👋")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text("Manage your household medicines with ease.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .listRowBackground(Color.clear)
                
                Section {
                    VStack(spacing: 12) {
                        Button {
                            showingMedicines = true
                        } label: {
                            HStack(alignment: .center){
                                Image(systemName: "pills.fill")
                                    .font(.system(size:32))
                                    .foregroundStyle(.blue)
                                Text("\(medicineViewModel.medicines.count)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                Text("Medicines")
                                    .font(.title2)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 120)
                            .background(Color("SkyBlue"))
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                        }
                        .buttonStyle(.plain)
                        
                        HStack(spacing: 12) {
                            Button {
                                showingExpiringSoon = true
                            } label: {
                                VStack {
                                    Image(systemName: "clock.badge.exclamationmark")
                                        .font(.system(size:32))
                                        .foregroundStyle(.orange)
                                    HStack(alignment: .center) {
                                        Text("\(expiryViewModel.expiringMedicines.count)")
                                            .font(.title)
                                            .fontWeight(.bold)
                                        Text("Expiring Soon")
                                            .font(.title2)
                                    }
                                    Text("Next 30 days")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 140)
                                .background(Color("Peach"))
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                            }
                            .buttonStyle(.plain)
                            
                            Button {
                                showingExpired = true
                            } label: {
                                VStack {
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .font(.system(size:32))
                                        .foregroundStyle(.red)
                                    HStack(alignment: .center) {
                                        Text("\(expiryViewModel.expiredMedicines.count)")
                                            .font(.title)
                                            .fontWeight(.bold)
                                        Text("Expired")
                                            .font(.title2)
                                    }
                                    Text("Need attention")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 140)
                                .background(Color("Coral"))
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                Section {
                    Label("Medicine Tip",systemImage:"lightbulb.fill")
                        .font(.headline)
                        .foregroundStyle(.orange)
                    HStack(alignment:.top,spacing:12){
                        Image(systemName:"info.circle.fill")
                            .foregroundStyle(.blue)
                        Text("Check expiry dates regularly and return expired or unwanted medicines to a participating community pharmacy through the NatRUM Program.")
                            .font(.subheadline)
                    }
                    .padding()
                    .background(Color("Mint"))
                    .clipShape(RoundedRectangle(cornerRadius:24))
                }
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
            .background(Color("Background"))
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

