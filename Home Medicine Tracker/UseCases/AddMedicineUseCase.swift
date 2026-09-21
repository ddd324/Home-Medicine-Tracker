//
//  AddMedicineUseCase.swift
//  Home Medicine Tracker
//
//  Created by Djy on 21/09/2026.
//

import Foundation

struct AddMedicineUseCase {
    
    enum AddMedicineError: Error {
        case emptyName
    }
    
    private let repository: MedicineRepository

    init(repository: MedicineRepository) {
        self.repository = repository
    }

    func execute(_ medicine: Medicine) throws {
        let trimmedName = medicine.name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            throw AddMedicineError.emptyName
        }
        
        try repository.addMedicine(medicine)
    }
}
