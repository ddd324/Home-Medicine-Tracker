//
//  MockStorageLocationRepository.swift
//  HomeMedicineTrackerTests
//
//  Created by Djy on 26/09/2026.
//

import Foundation
@testable import Home_Medicine_Tracker

final class MockStorageLocationRepository: StorageLocationRepository {
    var locations: [StorageLocation] = []
    var addedLocation: StorageLocation?

    func addStorageLocation(_ location: StorageLocation) throws {
        addedLocation = location
        locations.append(location)
    }

    func fetchStorageLocations() throws -> [StorageLocation] {
        locations
    }

    func updateStorageLocation(_ location: StorageLocation) throws {
        if let index = locations.firstIndex(where: { $0.id == location.id }) {
            locations[index] = location
        }
    }
}
