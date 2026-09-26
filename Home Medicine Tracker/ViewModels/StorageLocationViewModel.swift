//
//  StorageLocationViewModel.swift
//  Home Medicine Tracker
//
//  Created by Djy on 22/09/2026.
//

import Foundation
import Combine

@MainActor
final class  StorageLocationViewModel: ObservableObject {
    
    @Published var storageLocations: [StorageLocation] = []
    @Published var errorMessage: String?
    @Published var medicineCounts: [UUID: Int] = [:]
    
    private let getStorageLocationsUseCase: GetStorageLocationsUseCase
    private let addStorageLocationUseCase: AddStorageLocationUseCase
    private let updateStorageLocationUseCase: UpdateStorageLocationUseCase
    private let getMedicinesByStorageLocationUseCase: GetMedicinesByStorageLocationUseCase
    
    init(getStorageLocationsUseCase: GetStorageLocationsUseCase, addStorageLocationUseCase: AddStorageLocationUseCase, updateStorageLocationUseCase: UpdateStorageLocationUseCase, getMedicinesByStorageLocationUseCase: GetMedicinesByStorageLocationUseCase) {
        self.getStorageLocationsUseCase = getStorageLocationsUseCase
        self.addStorageLocationUseCase = addStorageLocationUseCase
        self.updateStorageLocationUseCase = updateStorageLocationUseCase
        self.getMedicinesByStorageLocationUseCase = getMedicinesByStorageLocationUseCase
    }
    
    func loadStorageLocations() {
        do {
            storageLocations = try getStorageLocationsUseCase.execute()
        } catch {
            print("Failed to load storage locations: \(error)")
        }
    }
    
    func addStorageLocation(_ location: StorageLocation) -> Bool {
        do {
            try addStorageLocationUseCase.execute(location)
            loadStorageLocations()
            errorMessage = nil
            return true
        } catch AddStorageLocationUseCase.AddStorageLocationError.emptyName {
            errorMessage = "Please enter a storage location name."
            return false
        } catch {
            errorMessage = "Unable to add this storage location. Please try again."
            return false
        }
    }
    
    func updateStorageLocation(_ location: StorageLocation) -> Bool {
        do {
            try updateStorageLocationUseCase.execute(location)
            loadStorageLocations()
            errorMessage = nil
            return true
        } catch UpdateStorageLocationUseCase.UpdateStorageLocationError.emptyName {
            errorMessage = "Please enter a storage location name."
            return false
        } catch {
            errorMessage = "Unable to update this storage location. Please try again."
            return false
        }
    }
    
    func loadMedicineCounts() {
        var counts: [UUID: Int] = [:]
        
        for location in storageLocations {
            do {
                let medicines = try getMedicinesByStorageLocationUseCase.execute(storageLocationID: location.id)
                counts[location.id] = medicines.count
            } catch {
                counts[location.id] = 0
            }
        }
        medicineCounts = counts
    }
    
    func medicineCount(for locationID: UUID) -> Int {
        medicineCounts[locationID] ?? 0
    }
}
