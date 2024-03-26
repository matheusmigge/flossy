//
//  NotificationManagerMock.swift
//  DidIFlossTests
//
//  Created by Lucas Migge on 26/03/24.
//

import Foundation
@testable import Notification

class NotificationManagerMock: FlossRemindersService {
    
    static func current() -> FlossRemindersService {
        return NotificationManagerMock()
    }
    
    func requestAuthorizationToNotificate(provisional: Bool) {
        
    }
    
    func scheduleAllFlossReminders(streakCount: Int) {
        
    }
    
    func scheduleInactivityFlossReminderNotifications() {
        
    }
    
    func clearPendingDailyStreakFlossReminderNotification() {
        
    }
    
    func clearAllPendingFlossReminderNotification() {
        
    }
    
    
    
}
