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
        let medicineName = userInfo["medicineName"] as? String ?? "Medicine"
        let expiryDate = userInfo["expiryDate"] as? String ?? "Not specified"
        let storageLocation = userInfo["storageLocation"] as? String ?? "Not specified"
        
        var message = NSMutableAttributedString()
        
        message.append(NSAttributedString(string: "Medicine Expiry Reminder\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 17)]))
        
        message.append(NSAttributedString(string: "\(medicineName)\n", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .semibold)]))
        
        message.append(NSAttributedString(string: "Expiry: \(expiryDate)\nStored in: \(storageLocation)", attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.secondaryLabel]))
        
        label?.attributedText = message
    }

}
