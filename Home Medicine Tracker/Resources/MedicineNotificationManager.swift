//
//  MedicineNotificationManager.swift
//  Home Medicine Tracker
//
//  Created by Djy on 25/09/2026.
//

import Foundation
import UserNotifications

struct MedicineNotificationManager {
    
    static let shared = MedicineNotificationManager()
    
    private init() {
        
    }
    
    func requestPermission() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            return false
        }
    }
    
    func scheduleExpiryNotification(for medicine: Medicine) async {
        guard medicine.reminderEnabled else {
            return
        }
        
        let center = UNUserNotificationCenter.current()
        let calendar = Calendar.current
        let reminderDays = [30, 7]
        
        for daysBeforeExpiry in reminderDays {
            guard let reminderDate = calendar.date(byAdding: .day, value:  -daysBeforeExpiry, to: medicine.expiryDate) else {
                continue
            }
            
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: reminderDate)
            dateComponents.hour = 9
            dateComponents.minute = 0
            
            guard let scheduledDate = calendar.date(from: dateComponents), scheduledDate > Date() else {
                continue
            }
            
            let content = UNMutableNotificationContent()
            content.title = "Medicine Expiring Soon"
            content.body = "\(medicine.name) will expire in \(daysBeforeExpiry) days."
            content.sound = .default
            content.categoryIdentifier = "MEDICINE_EXPIRY"
            
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            
            content.userInfo = ["medicineName": medicine.name, "expiryDate": formatter.string(from: medicine.expiryDate), "storageLocation": medicine.storageLocation?.name ?? "Not specified"]
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: "medicine-expiry-\(daysBeforeExpiry)-\(medicine.id.uuidString)", content: content, trigger: trigger)
            
            do {
                try await center.add(request)
            } catch {
                print("Unable to schedule \(daysBeforeExpiry)-day expiry notification.")
            }
        }
    }
    
    func cancelExpiryNotifications(for medicine: Medicine) {
        let identifiers = ["medicine-expiry-30-\(medicine.id.uuidString)", "medicine-expiry-7-\(medicine.id.uuidString)"]
        
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    func scheduleTestNotification(for medicine: Medicine) async {
        let content = UNMutableNotificationContent()
        content.title = "Medicine Expiring Soon"
        content.body = "\(medicine.name) is approaching its expiry date."
        content.sound = .default
        content.categoryIdentifier = "MEDICINE_EXPIRY"

        let formatter = DateFormatter()
        formatter.dateStyle = .long

        content.userInfo = [
            "medicineName": medicine.name,
            "expiryDate": formatter.string(from: medicine.expiryDate),
            "storageLocation": medicine.storageLocation?.name ?? "Not specified"
        ]

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 5,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: "medicine-expiry-test-\(medicine.id.uuidString)",
            content: content,
            trigger: trigger
        )

        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("Unable to schedule test notification.")
        }
    }
    
    func printNotificationStatus() async {
        let center = UNUserNotificationCenter.current()

        let settings = await center.notificationSettings()
        print("Notification authorization status: \(settings.authorizationStatus.rawValue)")

        let pendingRequests = await center.pendingNotificationRequests()
        print("Pending notifications: \(pendingRequests.count)")

        for request in pendingRequests {
            print("Pending: \(request.identifier)")
        }

        let deliveredNotifications = await center.deliveredNotifications()
        print("Delivered notifications: \(deliveredNotifications.count)")

        for notification in deliveredNotifications {
            print("Delivered: \(notification.request.identifier)")
        }
    }
}
