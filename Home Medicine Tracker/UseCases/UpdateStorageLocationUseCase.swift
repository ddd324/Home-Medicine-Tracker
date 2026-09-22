//
//  UpdateStorageLocationUseCase.swift
//  Home Medicine Tracker
//
//  Created by Djy on 22/09/2026.
//

import Foundation

struct UpdateStorageLocationUseCase {
    
    enum UpdateStorageLocationError: Error {
        case emptyName
    }
    
    private let repository: StorageLocationRepository
    
    init(repository: StorageLocationRepository) {
        self.repository = repository
    }
    
    func execute(_ location: StorageLocation) throws {
        let trimmedName = location.name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            throw UpdateStorageLocationError.emptyName
        }
        
        try repository.updateStorageLocation(location)
    }
}
