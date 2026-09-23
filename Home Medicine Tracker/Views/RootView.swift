//
//  RootView.swift
//  Home Medicine Tracker
//
//  Created by Djy on 20/09/2026.
//

import SwiftUI

struct RootView: View {
    
    private let medicineRepository: MedicineRepository
    
    init() {
        self.medicineRepository = JSONMedicineRepository()
    }
    
    var body: some View {
        TabView {
            Text("Home")
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            MedicineListView(repository: medicineRepository)
                .tabItem {
                    Label("Medicines", systemImage: "pills.fill")
                }

            StorageLocationListView(medicineRepository: medicineRepository)
                .tabItem {
                    Label("Storage", systemImage: "cylinder.split.1x2.fill")
                }
        }
    }
}

#Preview {
    RootView()
}
