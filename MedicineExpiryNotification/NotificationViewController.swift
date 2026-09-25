//
//  NotificationViewController.swift
//  MedicineExpiryNotification
//
//  Created by Djy on 25/09/2026.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        let content = notification.request.content
        let userInfo = content.userInfo
        let medicineName = userInfo["MedicineName"] as? String ?? "Medicine"
        let expiryDate = userInfo["expiryDate"] as? String ?? ""
        let storageLocation = userInfo["storageLocation"] as? String ?? ""
        
        var message = "\(medicineName) is expirying soon"
        
        if !expiryDate.isEmpty {
            message += "\nExpiry: \(expiryDate)"
        }
        
        if !storageLocation.isEmpty {
            message += "\nStored in: \(storageLocation)"
        }
        
        label?.text = message
    }

}
