//
//  GetExpiringMedicinesUseCase.swift
//  Home Medicine Tracker
//
//  Created by Djy on 23/09/2026.
//

import Foundation

struct GetExpiringMedicinesUseCase {
    
    private let repository: MedicineRepository
    
    init(repository: MedicineRepository) {
        self.repository = repository
    }
    
    func execute(within days: Int, from date: Date = Date()) throws -> [Medicine] {
        let calendar = Calendar.current
        
        let startOfToday = calendar.startOfDay(for: date)
        
        guard let endDate = calendar.date(byAdding: .day, value: days, to: startOfToday) else {
            return []
        }
        
        let medicines = try repository.fetchExpiringMedicines(before: endDate)
        
        return medicines.filter {
            $0.status == "active" && $0.expiryDate >= startOfToday && $0.expiryDate <= endDate
        }
        .sorted {
            $0.expiryDate < $1.expiryDate
        }
    }
}
