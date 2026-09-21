//
//  MarkMedicineAsReturnedUseCase.swift
//  Home Medicine Tracker
//
//  Created by Djy on 21/09/2026.
//

import Foundation

struct MarkMedicineAsReturnedUseCase {
    
    enum MarkMedicineAsReturnedError: Error {
        case alreadyReturned
    }
    
    private let repository: MedicineRepository
    
    init(repository: MedicineRepository) {
        self.repository = repository
    }
    
    func execute(_ medicine: Medicine) throws {
        guard medicine.status != "returned" else {
            throw MarkMedicineAsReturnedError.alreadyReturned
        }
        
        var updatedMedicine = medicine
        updatedMedicine.status = "returned"
        updatedMedicine.returnedDate = Date()
        
        try repository.updateMedicine(updatedMedicine)
    }
}
