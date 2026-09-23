//
//  AddStorageLocationUseCase.swift
//  Home Medicine Tracker
//
//  Created by Djy on 22/09/2026.
//

import Foundation

struct AddStorageLocationUseCase {
    
    enum AddStorageLocationError: Error {
        case emptyName
    }
    
    private let repository: StorageLocationRepository
    
    init(repository: StorageLocationRepository) {
        self.repository = repository
    }
    
    func execute(_ location: StorageLocation) throws {
        let trimmedName = location.name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            throw AddStorageLocationError.emptyName
        }
        
        try repository.addStorageLocation(location)
    }
}
