//
//  CoreDataStorageLocationRepository.swift
//  Home Medicine Tracker
//
//  Created by Djy on 21/09/2026.
//

import Foundation
import CoreData

struct CoreDataStorageLocationRepository: StorageLocationRepository {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addStorageLocation(_ location: StorageLocation) throws {
        let entity = StorageLocationEntity(context: context)
        entity.id = location.id
        entity.name = location.name
        entity.room = location.room
        entity.notes = location.notes
        entity.createdAt = location.createdAt
        
        try context.save()
    }
    
    func fetchStorageLocations() throws -> [StorageLocation] {
        let request = StorageLocationEntity.fetchRequest()
        let entities = try context.fetch(request)
        
        return entities.map { entity in
            StorageLocation(id: entity.id ?? UUID(), name: entity.name ?? "", room: entity.room, notes: entity.notes, createdAt: entity.createdAt ?? Date())
        }
    }
    
    
}
