//
//  GetMedicinesByStorageLocationUseCase.swift
//  Home Medicine Tracker
//
//  Created by Djy on 22/09/2026.
//

import Foundation

struct GetMedicinesByStorageLocationUseCase {
    
    private let repository: MedicineRepository
    
    init(repository: MedicineRepository) {
        self.repository = repository
    }
    
    func execute(storageLocationID: UUID) throws -> [Medicine] {
        try repository.fetchMedicines(forStorageLocationID: storageLocationID)
    }
}
