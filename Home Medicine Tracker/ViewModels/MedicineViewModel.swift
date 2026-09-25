//
//  MedicineViewModel.swift
//  Home Medicine Tracker
//
//  Created by Djy on 21/09/2026.
//

import Foundation
import Combine
import WidgetKit

enum MedicineFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case expiring = "Expiring"
    case expired = "Expired"

    var id: String { rawValue }
}

@MainActor
final class MedicineViewModel: ObservableObject {
    
    @Published var medicines: [Medicine] = []
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var selectedFilter: MedicineFilter = .all
    
    private let getMedicinesUseCase: GetMedicinesUseCase
    private let addMedicineUseCase: AddMedicineUseCase
    private let updateMedicineUseCase: UpdateMedicineUseCase
    private let markMedicineAsReturnedUseCase: MarkMedicineAsReturnedUseCase
    
    var availableCategories: [String] {
        let defaultCategories = [ "Pain Relief", "Eye Care", "Allergy", "Skin Treatment", "Cold & Flu"]
        let existingCategories = medicines
            .map { $0.category }
            .filter { !$0.isEmpty }
        
        return Array(Set(defaultCategories + existingCategories)).sorted()
    }
    
    var filteredMedicines: [Medicine] {
        medicines.filter { medicine in
            let matchesSearch = searchText.isEmpty || medicine.name.localizedCaseInsensitiveContains(searchText)
            let matchesFilter: Bool

            switch selectedFilter {
            case .all:
                matchesFilter = true

            case .expiring:
                matchesFilter = medicine.displayStatus == "Expiring"

            case .expired:
                matchesFilter = medicine.displayStatus == "Expired"
            }

            return matchesSearch && matchesFilter
        }
    }
    
    init(getMedicinesUseCase: GetMedicinesUseCase, addMedicineUseCase: AddMedicineUseCase, updateMedicineUseCase: UpdateMedicineUseCase, markMedicineAsReturnedUseCase: MarkMedicineAsReturnedUseCase) {
        self.getMedicinesUseCase = getMedicinesUseCase
        self.addMedicineUseCase = addMedicineUseCase
        self.updateMedicineUseCase = updateMedicineUseCase
        self.markMedicineAsReturnedUseCase = markMedicineAsReturnedUseCase
    }
    
    func loadMedicines() {
        do {
            medicines = try getMedicinesUseCase.execute()
            updateWidgetData()
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
            print("Failed to add medicine: \(error)")
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
    
    func markMedicineAsReturned(_ medicine: Medicine) -> Bool {
        do {
            try markMedicineAsReturnedUseCase.execute(medicine)
            loadMedicines()
            errorMessage = nil
            return true
        } catch MarkMedicineAsReturnedUseCase.MarkMedicineAsReturnedError.alreadyReturned {
            errorMessage = "This medicine has already been returned."
            return false
        } catch {
            errorMessage = "Unable to mark medicine as returned."
            return false
        }
    }
    
    private func updateWidgetData() {
        let widgetMedicines = medicines
            .filter { $0.displayStatus == "Expiring" }
            .sorted { $0.expiryDate < $1.expiryDate }
            .prefix(3)
            .map { medicine in
                WidgetMedicine(id: medicine.id, name: medicine.name, expiryDate: medicine.expiryDate, storageLocationName: medicine.storageLocation?.name)
            }
        WidgetMedicineData.save(Array(widgetMedicines))
        WidgetCenter.shared.reloadAllTimelines()
    }
}
