//
//  Medicine.swift
//  Home Medicine Tracker
//
//  Created by Djy on 20/09/2026.
//

import Foundation

struct Medicine: Identifiable, Equatable, Codable {
    let id: UUID
    var name: String
    var category: String
    var expiryDate: Date
    var notes: String?
    var photoData: Data?
    var reminderEnabled: Bool
    var status: String
    var createdAt: Date
    var returnedDate: Date?
    var storageLocation: StorageLocation?
    
    var displayStatus: String {
        if status == "returned" {
            return "Returned"
        }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let expiry = calendar.startOfDay(for: expiryDate)

        if expiry < today {
            return "Expired"
        }

        if let thirtyDaysLater = calendar.date(
            byAdding: .day,
            value: 30,
            to: today
        ),
           expiry <= thirtyDaysLater {
            return "Expiring"
        }

        return "Active"
    }
}
