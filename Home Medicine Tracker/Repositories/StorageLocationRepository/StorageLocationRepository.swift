//
//  StorageLocationRepository.swift
//  Home Medicine Tracker
//
//  Created by Djy on 21/09/2026.
//

import Foundation

protocol StorageLocationRepository {
    func addStorageLocation(_ location: StorageLocation) throws
    func fetchStorageLocations() throws -> [StorageLocation]
}
