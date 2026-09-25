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
    
    @Test func updatingValidMedicineSavesChanges() throws {
        let repository = MockMedicineRepository()
        let useCase = UpdateMedicineUseCase(repository: repository)
        
        let medicineID = UUID()
        
        let originalMedicine = Medicine(id: medicineID, name: "Paracetamol", category: "Pain Relief", expiryDate: Date(), notes: nil, photoData: nil, reminderEnabled: false, status: "active", createdAt: Date(), returnedDate: nil, storageLocation: nil)
        
        let updatedMedicine = Medicine(id: medicineID, name: "Paracetamol Tablets", category: "Pain Relief", expiryDate: Date(), notes: "Updated notes", photoData: nil, reminderEnabled: true, status: "active", createdAt: originalMedicine.createdAt, returnedDate: nil, storageLocation: nil)
        
        repository.medicines = [originalMedicine]
        
        try useCase.execute(updatedMedicine)
        
        #expect(repository.medicines.count == 1)
        #expect(repository.medicines.first?.name == "Paracetamol Tablets")
        #expect(repository.medicines.first?.notes == "Updated notes")
        #expect(repository.medicines.first?.reminderEnabled == true)
    }
    
    @Test func updatingMedicineWithEmptyNameThrowsEmptyNameError() throws {
        let repository = MockMedicineRepository()
        let useCase = UpdateMedicineUseCase(repository: repository)
        
        let medicine = Medicine(id: UUID(), name: "   ", category: "Pain Relief", expiryDate: Date(), notes: nil, photoData: nil, reminderEnabled: false, status: "active", createdAt: Date(), returnedDate: nil, storageLocation: nil)
        
        #expect(throws: UpdateMedicineUseCase.UpdateMedicineError.emptyName) {
            try useCase.execute(medicine)
        }
        
        #expect(repository.medicines.isEmpty)
    }
    
    @Test func updatingMedicineWithEmptyStringThrowsEmptyNameError() throws {
        let repository = MockMedicineRepository()
        let useCase = UpdateMedicineUseCase(repository: repository)
        
        let medicine = Medicine(id: UUID(), name: "", category: "Pain Relief", expiryDate: Date(), notes: nil, photoData: nil, reminderEnabled: false, status: "active", createdAt: Date(), returnedDate: nil, storageLocation: nil)
        
        #expect(throws: UpdateMedicineUseCase.UpdateMedicineError.emptyName) {
            try useCase.execute(medicine)
        }
        
        #expect(repository.medicines.isEmpty)
    }
    
    @Test func returningAlreadyReturnedMedicineThrowsAlreadyReturnedError() throws {
        let repository = MockMedicineRepository()
        let useCase = MarkMedicineAsReturnedUseCase(repository: repository)
        
        let medicine = Medicine(id: UUID(), name: "Paracetamol", category: "Pain Relief", expiryDate: Date(), notes: nil, photoData: nil, reminderEnabled: false, status: "returned", createdAt: Date(), returnedDate: nil, storageLocation: nil)
        
        repository.medicines = [medicine]
        
        #expect(throws: MarkMedicineAsReturnedUseCase.MarkMedicineAsReturnedError.alreadyReturned) {
            try useCase.execute(medicine)
        }
        
        #expect(repository.medicines.first?.status == "returned")
    }
    
    @Test func returningActiveMedicineUpdatesStatusAndReturnedDate() throws {
        let repository = MockMedicineRepository()
        let useCase = MarkMedicineAsReturnedUseCase(repository: repository)
        
        let medicine = Medicine(id: UUID(), name: "Paracetamol", category: "Pain Relief", expiryDate: Date(), notes: nil, photoData: nil, reminderEnabled: false, status: "active", createdAt: Date(), returnedDate: nil, storageLocation: nil)
        
        repository.medicines = [medicine]
        
        try useCase.execute(medicine)
        
        let updatedMedicine = repository.medicines.first
        
        #expect(updatedMedicine?.status == "returned")
        #expect(updatedMedicine?.returnedDate != nil)
        #expect(updatedMedicine?.id == medicine.id)
    }
}
