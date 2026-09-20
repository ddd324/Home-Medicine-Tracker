//
//  Home_Medicine_TrackerApp.swift
//  Home Medicine Tracker
//
//  Created by Djy on 20/09/2026.
//

import SwiftUI
import CoreData

@main
struct Home_Medicine_TrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
