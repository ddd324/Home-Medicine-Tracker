//
//  CoreDataMedicineRepository.swift
//  Home Medicine Tracker
//
//  Created by Djy on 20/09/2026.
//

import Foundation
import CoreData

struct CoreDataMedicineRepository: MedicineRepository {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addMedicine(_ medicine: Medicine) throws {
        let entity = MedicineEntity(context: context)
        entity.id = medicine.id
        entity.name = medicine.name
        entity.category = medicine.category
        entity.expiryDate = medicine.expiryDate
        entity.notes = medicine.notes
        entity.photoData = medicine.photoData
        entity.reminderEnabled = medicine.reminderEnabled
        entity.status = medicine.status
        entity.createdAt = medicine.createdAt
        entity.returnedDate = medicine.returnedDate
        
        if let location = medicine.storageLocation {
            let locationRequest = StorageLocationEntity.fetchRequest()
            locationRequest.predicate = NSPredicate(format: "id == %@", location.id as CVarArg)
            locationRequest.fetchLimit = 1
            entity.storageLocation = try context.fetch(locationRequest).first
        }
        
        try context.save()
    }
    
    func fetchMedicines() throws -> [Medicine] {
        let request = MedicineEntity.fetchRequest()
        let entities = try context.fetch(request)
        
        return entities.map(mapToMedicine)
    }
    
    func fetchExpiringMedicines(before date: Date) throws -> [Medicine] {
        let request = MedicineEntity.fetchRequest()
        
        request.predicate = NSPredicate(format: "status == %@ AND expiryDate <= %@", "active", date as NSDate)
        
        let entities = try context.fetch(request)
        
        return entities.map(mapToMedicine)
    }
    
    func updateMedicine(_ medicine: Medicine) throws {
        let request = MedicineEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", medicine.id as CVarArg)
        request.fetchLimit = 1
        
        guard let entity = try context.fetch(request).first else {
            return
        }
        
        entity.name = medicine.name
        entity.category = medicine.category
        entity.expiryDate = medicine.expiryDate
        entity.notes = medicine.notes
        entity.photoData = medicine.photoData
        entity.reminderEnabled = medicine.reminderEnabled
        entity.status = medicine.status
        entity.returnedDate = medicine.returnedDate
        
        if let location = medicine.storageLocation {
            let locationRequest = StorageLocationEntity.fetchRequest()
            locationRequest.predicate = NSPredicate(format: "id == %@", location.id as CVarArg)
            locationRequest.fetchLimit = 1
            entity.storageLocation = try context.fetch(locationRequest).first
        } else {
            entity.storageLocation = nil
        }
        
        try context.save()
    }
    
    private func mapToMedicine(_ entity: MedicineEntity) -> Medicine {
        let storageLocation: StorageLocation?
        
        if let location = entity.storageLocation {
            storageLocation = StorageLocation(id: location.id ?? UUID(), name: location.name ?? "", room: location.room, notes: location.notes, createdAt: location.createdAt ?? Date())
        } else {
            storageLocation = nil
        }
        
        return Medicine(id: entity.id ?? UUID(), name: entity.name ?? "", category: entity.category ?? "", expiryDate: entity.expiryDate ?? Date(), notes: entity.notes, photoData: entity.photoData, reminderEnabled: entity.reminderEnabled, status: entity.status ?? "active", createdAt: entity.createdAt ?? Date(), returnedDate: entity.returnedDate, storageLocation: storageLocation)
    }
}

