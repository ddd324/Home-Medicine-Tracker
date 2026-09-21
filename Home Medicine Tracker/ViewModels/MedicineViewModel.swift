//
//  MedicineViewModel.swift
//  Home Medicine Tracker
//
//  Created by Djy on 21/09/2026.
//

import Foundation
import Combine

@MainActor
final class MedicineViewModel: ObservableObject {
    
    @Published var medicines: [Medicine] = []
    @Published var errorMessage: String?
    
    private let getMedicinesUseCase: GetMedicinesUseCase
    private let addMedicineUseCase: AddMedicineUseCase
    
    init(getMedicinesUseCase: GetMedicinesUseCase, addMedicineUseCase: AddMedicineUseCase) {
        self.getMedicinesUseCase = getMedicinesUseCase
        self.addMedicineUseCase = addMedicineUseCase
    }
    
    func loadMedicines() {
        do {
            medicines = try getMedicinesUseCase.execute()
        } catch {
            print("Failed to load medicines: \(error)")
        }
    }
    
    func addMedicine(_ medicine: Medicine) -> Bool {
        do {
            try addMedicineUseCase.execute(medicine)
            loadMedicines()
            errorMessage = nil
            return true
        } catch AddMedicineUseCase.AddMedicineError.emptyName {
            errorMessage = "Medicine name cannot be empty."
            return false
        } catch {
            errorMessage = "Unable to add medicine."
            return false
        }
    }
}
