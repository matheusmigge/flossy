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
    
    /// The shared instance of `UNUserNotificationCenter` for managing notifications.
    static private var center: UNUserNotificationCenter {
        UNUserNotificationCenter.current()
    }
    
    /// Requests user authorization for notifications.
    ///
    /// - Parameter provisional: A boolean indicating whether to request provisional authorization.
    ///
    /// Requests authorization to display alerts, play sounds, and update the badge icon.
    /// If `provisional` is true, also requests provisional authorization for quiet notifications.
    static public func requestAuthorizationToNotificate(provisional: Bool = true) {
        var requestOptions: UNAuthorizationOptions {
            provisional ? [.alert, .sound, .badge, .provisional] : [.alert, .sound, .badge]
        }
        
        center.requestAuthorization(options: requestOptions) { granted, error in
            if granted {
                print("\(provisional ? "Provisional" : "Full") Notification permission granted")
            } else {
                print("\(provisional ? "Provisional" : "Full") Notification permission denied")
                if let error = error {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    /// Checks if the app has notification authorization.
    ///
    /// - Parameter completion: A closure that receives a boolean indicating whether the app has notification authorization.
    ///
    /// Calls the completion handler with `true` if the app has authorization, otherwise with `false`.
    static private func checkNotificationAuthorization(completion: @escaping (Bool) -> Void) {
        center.getNotificationSettings { settings in
            let status = settings.authorizationStatus
            
            if status == .authorized || status == .provisional {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    /// Schedules a notification based on the provided `Notification` type.
    ///
    /// - Parameter notification: The `Notification` type to schedule.
    ///
    /// Creates a `UNNotificationRequest` and schedules it using the shared notification center.
    private static func scheduleNotification(type notification: NotificationModel) {
        let content = notification.content
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: notification.timeInterval,
                                                        repeats: notification.shouldRepeat)
        
        let request = UNNotificationRequest(identifier: notification.id,
                                            content: content,
                                            trigger: trigger)
        
        center.add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully -> id: \(notification.id)")
            }
        }
    }
    
    /// Schedules floss reminders notifications based on the defined notifications.
    ///
    /// Clears existing floss reminders notifications and schedules new ones if the app has notification authorization.
    static public func scheduleFlossRemindersNotifications() {
        self.clearAllFlossRemindersNotifications()
        
        self.checkNotificationAuthorization { hasPermission in
            if hasPermission {
                let notifications = FlossReminder.getAllNotifications()
                
                notifications.forEach { notification in
                    self.scheduleNotification(type: notification)
                }
            } else {
                print("Notification Failed To Schedule: Permission Denied")
            }
        }
    }
    
    /// Clears all pending floss reminders notifications.
    ///
    /// Removes all pending notification requests associated with floss reminders.
    static public func clearAllFlossRemindersNotifications() {
        let notificationsIds = FlossReminder.getAllNotifications().map { $0.id }
        center.removePendingNotificationRequests(withIdentifiers: notificationsIds)
    }
}



