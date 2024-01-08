//
//  NotificationManager.swift
//  DidIFloss
//
//  Created by Lucas Migge on 08/01/24.
//

import Foundation
import UserNotifications

struct NotificationManager {
    
    static var center: UNUserNotificationCenter {
        UNUserNotificationCenter.current()
    }
    
    // MARK: Notification Auth
    
    static func requestAuthorizationToNotificate() {
        center.requestAuthorization(options: [.alert, .sound, .badge, .provisional]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
                if let error = error {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    static func hasAuthorizationToNotificate(handler: @escaping (Bool) -> Void) {
        center.getNotificationSettings { settings in
            let status = settings.authorizationStatus
            if status == .authorized || status == .provisional {
                handler(true)
            } else {
                handler(false)
            }
        }
    }
    
   
}

