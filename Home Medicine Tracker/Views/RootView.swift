//
//  RootView.swift
//  Home Medicine Tracker
//
//  Created by Djy on 20/09/2026.
//

import SwiftUI

struct RootView: View {
    
    private let medicineRepository: MedicineRepository
    private let storageLocationRepository: StorageLocationRepository
    
    init() {
        self.medicineRepository = JSONMedicineRepository()
        self.storageLocationRepository = JSONStorageLocationRepository()
    }
    
    var body: some View {
        TabView {
            HomeView(medicineRepository: medicineRepository, storageLocationRepository: storageLocationRepository)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            MedicineListView(repository: medicineRepository, storageLocationRepository: storageLocationRepository)
                .tabItem {
                    Label("Medicines", systemImage: "pills.fill")
                }

            StorageLocationListView(medicineRepository: medicineRepository, storageLocationRepository: storageLocationRepository)
                .tabItem {
                    Label("Storage", systemImage: "cylinder.split.1x2.fill")
                }
        }
    }
}

#Preview {
    RootView()
}
