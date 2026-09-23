//
//  GetStorageLocationsUseCase.swift
//  Home Medicine Tracker
//
//  Created by Djy on 22/09/2026.
//

import Foundation

struct GetStorageLocationsUseCase {
    
    private let repository: StorageLocationRepository
    
    init(repository: StorageLocationRepository) {
        self.repository = repository
    }
    
    func execute() throws -> [StorageLocation] {
        try repository.fetchStorageLocations()
    }
}
