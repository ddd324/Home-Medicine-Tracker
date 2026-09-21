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
    private let updateMedicineUseCase: UpdateMedicineUseCase
    
    init(getMedicinesUseCase: GetMedicinesUseCase, addMedicineUseCase: AddMedicineUseCase, updateMedicineUseCase: UpdateMedicineUseCase) {
        self.getMedicinesUseCase = getMedicinesUseCase
        self.addMedicineUseCase = addMedicineUseCase
        self.updateMedicineUseCase = updateMedicineUseCase
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
    
    func updateMedicine(_ medicine: Medicine) -> Bool {
        do {
            try updateMedicineUseCase.execute(medicine)
            loadMedicines()
            errorMessage = nil
            return true
        } catch UpdateMedicineUseCase.UpdateMedicineError.emptyName {
            errorMessage = "Medicine name cannot be empty."
            return false
        } catch {
            errorMessage = "Unable to update medicine."
            return false
        }
    }
}
