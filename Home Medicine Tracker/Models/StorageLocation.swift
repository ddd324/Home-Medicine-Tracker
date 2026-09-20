//
//  StorageLocation.swift
//  Home Medicine Tracker
//
//  Created by Djy on 20/09/2026.
//

import Foundation

struct StorageLocation: Identifiable, Equatable {
    let id: UUID
    var name: String
    var room: String?
    var notes: String?
    var createdAt: Date
}
