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
    
    static func requestAuthorizationToNotificate(provisional: Bool = true) {
        var requestOptions: UNAuthorizationOptions {
            provisional ? [.alert, .sound, .badge, .provisional] : [.alert, .sound, .badge]
        }
        
        center.requestAuthorization(options: requestOptions) { granted, error in
            if granted {
                print("\(provisional ? "Provisional" : "Full") Notification permission granted")
            } else {
                print("\(provisional ? "Provisional" : "Full") Notification permission denied")
                if let error = error {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    static private func checkNotificationAuthorization(completion: @escaping (Bool) -> Void) {
        center.getNotificationSettings { settings in
            let status = settings.authorizationStatus

            if status == .authorized || status == .provisional {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    
    // MARK: Notification Schedule
    
    static func scheduleNotifications() {
        self.clearNotifications()
        
        self.checkNotificationAuthorization { permission in
            if permission {
                Notification.allCases.forEach { notification in
                    self.scheduleNotification(type: notification)
                }
            }
        }
    }
    
    private static func scheduleNotification(type notification: Notification){
        let content = UNMutableNotificationContent()
        content.title = notification.title
        content.body = notification.body
        content.sound = notification.sound
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: notification.timeInterval,
                                                        repeats: notification.shouldRepeat)
        
        let request = UNNotificationRequest(identifier: notification.id,
                                            content: content,
                                            trigger: trigger)
        
        center.add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully -> id> \(notification.id)")
            }
        }
    }
    
    static func clearNotifications() {
        var notificationsIds: [String] {
            Notification.allCases.map { $0.id }
        }
        
        center.removePendingNotificationRequests(withIdentifiers: notificationsIds)
        print("Notifications cleared")
    }
}

