//
//  JSONStorageLocationRepository.swift
//  Home Medicine Tracker
//
//  Created by Djy on 22/09/2026.
//

import Foundation

final class JSONStorageLocationRepository: StorageLocationRepository {
    
    private var locations: [StorageLocation] = []
    
    init() {
        loadStorageLocations()
    }
    
    func addStorageLocation(_ location: StorageLocation) throws {
        locations.append(location)
    }
    
    func fetchStorageLocations() throws -> [StorageLocation] {
        locations
    }
    
    func updateStorageLocation(_ location: StorageLocation) throws {
        guard let index = locations.firstIndex(where: { $0.id == location.id}) else {
            return
        }
        
        locations[index] = location
    }
    
    private func loadStorageLocations() {
        guard let url = Bundle.main.url(forResource: "SampleStorageLocations", withExtension: "json") else {
            print("SampleStorageLocations.json not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            locations = try decoder.decode([StorageLocation].self, from: data)
        } catch {
            print("Failed to load storage locations: \(error)")
        }
    }
}
