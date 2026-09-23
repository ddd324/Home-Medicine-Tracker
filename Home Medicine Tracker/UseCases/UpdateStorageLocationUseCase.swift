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
    
    private let storageLocationRepository: StorageLocationRepository
    private let medicineRepository: MedicineRepository
    
    init(storageLocationRepository: StorageLocationRepository, medicineRepository: MedicineRepository) {
        self.storageLocationRepository = storageLocationRepository
        self.medicineRepository = medicineRepository
    }
    
    func execute(_ location: StorageLocation) throws {
        let trimmedName = location.name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            throw UpdateStorageLocationError.emptyName
        }
        
        try storageLocationRepository.updateStorageLocation(location)
        try medicineRepository.updateStorageLocation(location)
    }
}
