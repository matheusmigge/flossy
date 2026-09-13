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
        let periods = Inactivity.Period.allCases
        
        return periods.map { Inactivity.createInactivityNotification(period: $0) }
    }
    
    static func getAllInactivityReminderIds() -> [String] {
        let periods = Inactivity.Period.allCases
        
        return periods.map { $0.id }
    }
    
    static func getDailyStreakReminderId() -> String {
        return DailyStreakReminder.notificationId
    }
    
    static func getADailyStreakReminderModel(daysOnStreak days: Int) -> NotificationModel {
        return DailyStreakReminder.createDailyStreakReminderModel(daysOnStreak: days)
    }
    
}

