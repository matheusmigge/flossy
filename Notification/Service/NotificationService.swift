//
//  NotificationService.swift
//  DidIFloss
//
//  Created by Lucas Migge on 09/01/24.
//

import Foundation
import UserNotifications


/// A utility struct for managing notifications in the DidIFloss app.
///
/// Use the `NotificationService` struct to request notification authorization, schedule notifications,
/// and manage floss reminders.
public struct NotificationService: FlossRemindersService {
    
    // MARK: init
    
    init(center: UNUserNotificationCenterable = UNUserNotificationCenter.current()) {
        self.center = center
    }
    
    let center: UNUserNotificationCenterable
    
    /// The standard method for utilizing NotificationService
    static public func current() -> NotificationService {
        NotificationService()
    }
    
    
    // MARK: Auth
    
    /// Requests user authorization for notifications.
    ///
    /// - Parameter provisional: A boolean indicating whether to request provisional authorization.
    ///
    /// Requests authorization to display alerts, play sounds, and update the badge icon.
    /// If `provisional` is true, also requests provisional authorization for quiet notifications.
    public func requestAuthorizationToNotificate(provisional: Bool = true) {
        var requestOptions: UNAuthorizationOptions {
            provisional ? [.alert, .sound, .badge, .provisional] : [.alert, .sound, .badge]
        }
        
        center.requestAuthorization(options: requestOptions) { granted, error in
            if granted {
//                print("\(provisional ? "Provisional" : "Full") Notification permission granted")
            } else {
                print("\(provisional ? "Provisional" : "Full") Notification permission denied")
                if let error = error {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    // MARK: Generic functions
    
    /// Schedules a notification based on the provided `NotificationModel` type.
    ///
    /// - Parameter notification: The `NotificationModel` type to schedule.
    ///
    /// Creates a `UNNotificationRequest` and schedules it using the shared notification center.
    public func scheduleNotification(type notification: NotificationModel) {
        let content = notification.content
        
        let trigger = notification.trigger
        
        let request = UNNotificationRequest(identifier: notification.id,
                                            content: content,
                                            trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully -> id: \(notification.id)")
            }
        }
    }
    
    /// Clears all pending notifications scheduled
    ///
    /// Removes all pending notification requests. Please use with caution
    public func clearAllPendingNotifications() {
        center.removeAllPendingNotificationRequests()
    }
    
    
    // MARK: Floss Reminder
    
    public func scheduleFlossReminders(streakCount: Int) {
        self.clearAllPendingFlossReminderNotification()
        
        self.scheduleDailyStreakReminder(streakCount: streakCount)
        self.scheduleFlossRemindersNotifications()
    }
    
    public func clearAllPendingFlossReminderNotification() {
        var ids: [String] = FlossReminder.getAllInactivityReminderIds()
        
        ids.append(FlossReminder.getDailyStreakReminderId())
        
        center.removePendingNotificationRequests(withIdentifiers: ids)
       
    }
    
    // MARK: FlossReminders - Inactivity
    
    /// Schedules floss reminders notifications based on the defined notifications.
    ///
    /// Clears existing floss reminders notifications and schedules new ones if the app has notification authorization.
    public func scheduleFlossRemindersNotifications() {
        let notifications = FlossReminder.getAllInactivityReminderModels()
        
        notifications.forEach { notification in
            self.scheduleNotification(type: notification)
        }
    }
    
    // MARK: FlossReminders - Streak
    
    public func scheduleDailyStreakReminder(streakCount: Int) {
        let notificationModel = FlossReminder.getADailyStreakReminderModel(daysOnStreak: streakCount)
        
        self.scheduleNotification(type: notificationModel)
    }
    
}



