//
//  RootView.swift
//  Home Medicine Tracker
//
//  Created by Djy on 20/09/2026.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            Text("Home")
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            MedicineListView()
                .tabItem {
                    Label("Medicines", systemImage: "pills.fill")
                }

            Text("Storage")
                .tabItem {
                    Label("Storage", systemImage: "cylinder.split.1x2.fill")
                }
        }
    }
}

#Preview {
    RootView()
}
