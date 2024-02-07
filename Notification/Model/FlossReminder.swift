//
//  Notification.swift
//  DidIFloss
//
//  Created by Lucas Migge on 08/01/24.
//

import Foundation
import UserNotifications

struct FlossReminder {
    
    static func getAllInactivityReminderModels() -> [NotificationModel] {
        
        let periods = InactivityReminder.Period.allCases
        
        return periods.map { type in
            InactivityReminder.createInactivityNotification(period: type)
        }
        
    }
    
    static func getAllInactivityReminderIds() -> [String] {
        
        let periods = InactivityReminder.Period.allCases
        
        return periods.map { $0.id }
        
    }
    
    static func getDailyStreakReminderId() -> String {
        return DailyStreakReminder.notificationId
    }
    
}

extension FlossReminder {
    
    struct DailyStreakReminder {
        
        static let notificationId: String = "dailyStreakNotification"
        
        static func createDailyStreakReminderModel(daysOnStreak days: Int) -> NotificationModel {
            return NotificationModel(id: notificationId,
                                     titleMessage: "You are amazing! Keep going",
                                     bodyMessage: "You are \(days) on streak. Don't forget to floss today",
                                     trigger: UNNotificationTrigger.tomorrowAtNight())
        }
        
    }
}

extension FlossReminder {
    
    struct InactivityReminder {
        enum Period: String, Identifiable, CaseIterable {
            case threeDays
            case oneWeek
            case twoWeek
            
            var id: String { self.rawValue }
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

