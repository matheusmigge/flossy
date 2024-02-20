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
            case fiveDays
            
            var id: String { self.rawValue + "InactivityNotification" }
        }
        
        
        static func createInactivityNotification(period: Period) -> NotificationModel {
            switch period {
            case .threeDays:
                return NotificationModel(
                    id: period.id,
                    titleMessage: "We miss you! 🦷",
                    bodyMessage:  "When was the last day you floss? What about we make it today?",
                    trigger: UNNotificationTrigger.afterDays(days: 3)
                )
            case .fiveDays:
                return NotificationModel(
                    id: period.id,
                    titleMessage: "Hey Stranger... 🫂",
                    bodyMessage: "We can help you with your oral hygiene. Let's floss those teeth!",
                    trigger: UNNotificationTrigger.afterDays(days: 5, repeats: true)
                )
            }
        }
    }
}
