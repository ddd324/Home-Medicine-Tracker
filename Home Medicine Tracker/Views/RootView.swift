//
//  RootView.swift
//  Home Medicine Tracker
//
//  Created by Djy on 20/09/2026.
//

import SwiftUI
import CoreData

struct RootView: View {
    
    private let medicineRepository: MedicineRepository
    private let storageLocationRepository: StorageLocationRepository
    
    init() {
        let context = PersistenceController.shared.container.viewContext
        self.medicineRepository = CoreDataMedicineRepository(context: context)
        self.storageLocationRepository = CoreDataStorageLocationRepository(context: context)
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
