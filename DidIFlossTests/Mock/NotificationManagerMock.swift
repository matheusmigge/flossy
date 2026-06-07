//
//  NotificationManagerMock.swift
//  DidIFlossTests
//
//  Created by Lucas Migge on 26/03/24.
//

import Foundation
@testable import FlossyReminders

class NotificationManagerMock: FlossyRemindersService {
    
    var didCallRequestAuth: Bool = false
    var didScheduleDailyNotification: Bool = false
    var didScheduleInactivityNotification: Bool = false
    var didScheduleAllNotifications: Bool = false

    var didRemoveAllPendingNotifications: Bool = false
    var didRemovePendingDailyNotification: Bool = false
    
    func requestAuthorizationToNotificate(provisional: Bool) {
        didCallRequestAuth = true
    }
    
    func scheduleAllFlossReminders(streakCount: Int) {
        didScheduleDailyNotification = true
        didScheduleInactivityNotification = true
        didScheduleAllNotifications = true
    }
    
    func scheduleInactivityFlossReminderNotifications() {
        didScheduleInactivityNotification = true
    }
    
    func clearPendingDailyStreakFlossReminderNotification() {
        didRemovePendingDailyNotification = true
    }
    
    func clearAllPendingFlossReminderNotification() {
        didRemoveAllPendingNotifications = true
        didRemovePendingDailyNotification = true
    }
    
    
    
}
