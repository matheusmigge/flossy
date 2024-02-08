//
//  FlossRemindersService.swift
//  Notification
//
//  Created by Lucas Migge on 08/02/24.
//

import Foundation


protocol FlossRemindersService {
    static func current() -> NotificationService
    
    func requestAuthorizationToNotificate(provisional: Bool)
    
    func scheduleFlossReminders(streakCount: Int)
    
    func clearAllPendingFlossReminderNotification() 
    
}
