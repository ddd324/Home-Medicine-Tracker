//
//  GetExpiredMedicinesUseCase.swift
//  Home Medicine Tracker
//
//  Created by Djy on 23/09/2026.
//

import Foundation

struct GetExpiredMedicinesUseCase {
    
    private let repository: MedicineRepository
    
    init(repository: MedicineRepository) {
        self.repository = repository
    }
    
    func execute(from date: Date = Date()) throws -> [Medicine] {
        let startOfToday = Calendar.current.startOfDay(for: date)
        let medicines = try repository.fetchMedicines()
        
        return medicines.filter {
            $0.status == "active" &&
            $0.expiryDate < startOfToday
        }
        .sorted {
            $0.expiryDate < $1.expiryDate
        }
    }
}
