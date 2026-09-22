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
    
    private let getStorageLocationsUseCase: GetStorageLocationsUseCase
    private let addStorageLocationUseCase: AddStorageLocationUseCase
    
    init(getStorageLocationsUseCase: GetStorageLocationsUseCase, addStorageLocationUseCase: AddStorageLocationUseCase) {
        self.getStorageLocationsUseCase = getStorageLocationsUseCase
        self.addStorageLocationUseCase = addStorageLocationUseCase
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
            errorMessage = "Storage location name cannot be empty."
            return false
        } catch {
            errorMessage = "Unable to add storage location."
            return false
        }
    }
}
