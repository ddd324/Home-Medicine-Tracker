//
//  GetMedicinesUseCase.swift
//  Home Medicine Tracker
//
//  Created by Djy on 21/09/2026.
//

import Foundation

struct GetMedicinesUseCase {
    private let repository: MedicineRepository

    init(repository: MedicineRepository) {
        self.repository = repository
    }

    func execute() throws -> [Medicine] {
        let medicines = try repository.fetchMedicines()

        return medicines.filter {
            $0.status == "active"
        }
    }
}
