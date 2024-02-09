//
//  FlossReminder+Inactivity.swift
//  Notification
//
//  Created by Lucas Migge on 07/02/24.
//

import Foundation
import UserNotifications


extension FlossReminder {
    
    struct Inactivity {
        enum Period: String, Identifiable, CaseIterable {
            case threeDays
            case oneWeek
            case twoWeek
            
            var id: String { self.rawValue + "InactivityNotification" }
        }
        
        
        static func createInactivityNotification(period: Period) -> NotificationModel {
            switch period {
            case .threeDays:
                return NotificationModel(
                    id: period.id,
                    titleMessage: "Don't lose track! 🦷",
                    bodyMessage:  "You are doing great! Don't forget to floss today and register it",
                    trigger: UNNotificationTrigger.afterDays(days: 3)
                )
            case .oneWeek:
                return NotificationModel(
                    id: period.id,
                    titleMessage: "Don't lose track! 🦷",
                    bodyMessage:  "You are doing great! Don't forget to floss today and register it",
                    trigger: UNNotificationTrigger.afterDays(days: 3)
                )
            case .twoWeek:
                return NotificationModel(
                    id: period.id,
                    titleMessage: "Hey Stranger... 🫂",
                    bodyMessage: "We can help you with your oral hygiene. Let's floss those teeth!",
                    trigger: UNNotificationTrigger.afterDays(days: 14, repeats: true)
                )
            }
        }
    }
}
