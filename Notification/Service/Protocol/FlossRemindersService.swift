//
//  FlossRemindersService.swift
//  Notification
//
//  Created by Lucas Migge on 08/02/24.
//

import Foundation


public protocol FlossRemindersService {
    static func current() -> NotificationService
    
    func requestAuthorizationToNotificate(provisional: Bool)
    
    func scheduleAllFlossReminders(streakCount: Int)
    
    func scheduleInactivityFlossReminderNotifications()
    
    func clearPendingDailyStreakFlossReminderNotification()
    
    func clearAllPendingFlossReminderNotification()
    
}
