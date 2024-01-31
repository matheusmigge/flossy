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
public struct NotificationService {
    
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
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: notification.timeInterval,
                                                        repeats: notification.shouldRepeat)
        
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
    
    // MARK: FlossReminders
    
    /// Schedules floss reminders notifications based on the defined notifications.
    ///
    /// Clears existing floss reminders notifications and schedules new ones if the app has notification authorization.
    public func scheduleFlossRemindersNotifications() {
        self.clearAllFlossRemindersNotifications()
        
        let notifications = FlossReminder.getAllNotifications()
        
        notifications.forEach { notification in
            self.scheduleNotification(type: notification)
        }
    }
    
    /// Clears all pending floss reminders notifications.
    ///
    /// Removes all pending notification requests associated with floss reminders.
    public func clearAllFlossRemindersNotifications() {
        let notificationsIds = FlossReminder.getAllNotifications().map { $0.id }
        center.removePendingNotificationRequests(withIdentifiers: notificationsIds)
    }
    
    
    /// Clears all pending notifications scheduled
    ///
    /// Removes all pending notification requests. Please use with caution
    public func clearAllPendingNotifications() {
        center.removeAllPendingNotificationRequests()
    }
    
}



