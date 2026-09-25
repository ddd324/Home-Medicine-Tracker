//
//  HomeMedicineTrackerTests.swift
//  HomeMedicineTrackerTests
//
//  Created by Djy on 25/09/2026.
//

import Testing
import Foundation
@testable import Home_Medicine_Tracker

struct HomeMedicineTrackerTests {

    @Test func addingMedicineWithEmptyNameThrowsEmptyNameError() throws {
        let repository = MockMedicineRepository()
        let useCase = AddMedicineUseCase(repository: repository)
        let medicine = Medicine(id: UUID(), name: "   ", category: "Pain Relief", expiryDate: Date(), notes: nil, photoData: nil, reminderEnabled: false, status: "active", createdAt: Date(), returnedDate: nil, storageLocation: nil)
        
        #expect(throws: AddMedicineUseCase.AddMedicineError.emptyName) {
            try useCase.execute(medicine)
        }
        
        #expect(repository.addedMedicine == nil)
    }
    
    @Test func addingMedicineWithEmptyStringThrowsEmptyNameError() throws {
        let repository = MockMedicineRepository()
        let useCase = AddMedicineUseCase(repository: repository)
        
        let medicine = Medicine(id: UUID(), name: "", category: "Pain Relief", expiryDate: Date(), notes: nil, photoData: nil, reminderEnabled: false, status: "active", createdAt: Date(), returnedDate: nil, storageLocation: nil)
        
        #expect(throws: AddMedicineUseCase.AddMedicineError.emptyName) {
            try useCase.execute(medicine)
        }
    }
    
    @Test func addingValidMedicineSavesMedicine() throws {
        let repository = MockMedicineRepository()
        let useCase = AddMedicineUseCase(repository: repository)
        let medicine = Medicine(id: UUID(), name: "Paracetamol", category: "Pain Relief", expiryDate: Date(), notes: nil, photoData: nil, reminderEnabled: false, status: "active", createdAt: Date(), returnedDate: nil, storageLocation: nil)
        
        try useCase.execute(medicine)
        
        #expect(repository.addedMedicine?.id == medicine.id)
        #expect(repository.addedMedicine?.name == "Paracetamol")
        #expect(repository.medicines.count == 1)
    }
    
    
}
