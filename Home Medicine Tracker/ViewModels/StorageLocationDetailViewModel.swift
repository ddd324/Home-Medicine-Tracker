//
//  StorageLocationDetailViewModel.swift
//  Home Medicine Tracker
//
//  Created by Djy on 22/09/2026.
//

import Foundation
import Combine

@MainActor
final class StorageLocationDetailViewModel: ObservableObject {
    
    @Published var medicines: [Medicine] = []
    
    private let getMedicinesByStorageLocationUseCase : GetMedicinesByStorageLocationUseCase
    
    init(getMedicinesByStorageLocationUseCase: GetMedicinesByStorageLocationUseCase) {
        self.getMedicinesByStorageLocationUseCase = getMedicinesByStorageLocationUseCase
    }
    
    func loadMedicines(storageLocationID: UUID) {
        do {
            medicines = try getMedicinesByStorageLocationUseCase.execute(storageLocationID: storageLocationID)
        } catch {
            print("Failed to load medicines for storage location: \(error)")
        }
    }
}
