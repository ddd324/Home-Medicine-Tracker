//
//  MockMedicineRepository.swift
//  HomeMedicineTrackerTests
//
//  Created by Djy on 25/09/2026.
//

import Foundation
@testable import Home_Medicine_Tracker

final class MockMedicineRepository: MedicineRepository {

    var medicines: [Medicine] = []
    var addedMedicine: Medicine?
    var updatedStorageLocation: StorageLocation?

    func addMedicine(_ medicine: Medicine) throws {
        addedMedicine = medicine
        medicines.append(medicine)
    }

    func fetchMedicines() throws -> [Medicine] {
        medicines
    }

    func fetchExpiringMedicines(before date: Date) throws -> [Medicine] {
        medicines.filter { medicine in
            medicine.status == "active" &&
            medicine.expiryDate <= date
        }
    }

    func updateMedicine(_ medicine: Medicine) throws {
        if let index = medicines.firstIndex(where: { $0.id == medicine.id }) {
            medicines[index] = medicine
        }
    }

    func fetchMedicines(forStorageLocationID id: UUID) throws -> [Medicine] {
        medicines.filter { medicine in
            medicine.storageLocation?.id == id
        }
    }

    func updateStorageLocation(_ location: StorageLocation) throws {
        updatedStorageLocation = location
    }
}
