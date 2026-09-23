//
//  MedicineRepository.swift
//  Home Medicine Tracker
//
//  Created by Djy on 20/09/2026.
//

import Foundation

protocol MedicineRepository {
    func addMedicine(_ medicine: Medicine) throws
    
    func fetchMedicines() throws -> [Medicine]
    
    func fetchExpiringMedicines(before date: Date) throws -> [Medicine]
    
    func updateMedicine(_ medicine: Medicine) throws
    
    func fetchMedicines(forStorageLocationID id: UUID) throws -> [Medicine]
}
