//
//  JSONMedicineRepository.swift
//  Home Medicine Tracker
//
//  Created by Djy on 21/09/2026.
//

import Foundation

final class JSONMedicineRepository: MedicineRepository {
    
    private var medicines: [Medicine] = []
    
    init() {
        loadMedicines()
    }
    
    func addMedicine(_ medicine: Medicine) throws {
        medicines.append(medicine)
    }
    
    func fetchMedicines() throws -> [Medicine] {
        medicines
    }
    
    func fetchExpiringMedicines(before date: Date) throws -> [Medicine] {
        medicines.filter {
            $0.status == "active" &&
            $0.expiryDate <= date
        }
    }
    
    func updateMedicine(_ medicine: Medicine) throws {
        guard let index = medicines.firstIndex(where: { $0.id == medicine.id }) else {
            return
        }
        
        medicines[index] = medicine
    }
    
    private func loadMedicines() {
        guard let url = Bundle.main.url(
            forResource: "SampleMedicines",
            withExtension: "json"
        ) else {
            print("SampleMedicines.json not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            medicines = try decoder.decode([Medicine].self, from: data)
        } catch {
            print("Failed to load medicines: \(error)")
        }
    }
    
    func fetchMedicines(forStorageLocationID id: UUID) throws -> [Medicine] {
        medicines.filter {
            $0.storageLocation?.id == id &&
            $0.status == "active"
        }
    }
}
