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
    
    private let getStorageLocationsUseCase: GetStorageLocationsUseCase
    
    init(getStorageLocationsUseCase: GetStorageLocationsUseCase) {
        self.getStorageLocationsUseCase = getStorageLocationsUseCase
    }
    
    func loadStorageLocations() {
        do {
            storageLocations = try getStorageLocationsUseCase.execute()
        } catch {
            print("Failed to load storage locations: \(error)")
        }
    }
}
