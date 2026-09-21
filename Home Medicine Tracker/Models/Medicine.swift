//
//  Medicine.swift
//  Home Medicine Tracker
//
//  Created by Djy on 20/09/2026.
//

import Foundation

struct Medicine: Identifiable, Equatable {
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
}
