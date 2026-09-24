//
//  WidgetMedicine.swift
//  Home Medicine Tracker
//
//  Created by Djy on 24/09/2026.
//

import Foundation

struct WidgetMedicine: Codable, Identifiable {
    let id: UUID
    let name: String
    let expiryDate: Date
    let storageLocationName: String?
}

enum WidgetMedicineData {
    static let appGroupID = "group.com.jiayi.Home-Medicine-Tracker"
    static let storageKey = "expiringMedicines"
    
    static func save(_ medicines: [WidgetMedicine]) {
        guard let defaults = UserDefaults(suiteName: appGroupID), let data = try? JSONEncoder().encode(medicines) else {
            return
        }
        
        defaults.set(data, forKey: storageKey)
    }
    
    static func load() -> [WidgetMedicine] {
        guard let defaults = UserDefaults(suiteName: appGroupID), let data = defaults.data(forKey: storageKey), let medicines = try? JSONDecoder().decode([WidgetMedicine].self, from: data) else {
            return []
        }
        return medicines
    }
}
