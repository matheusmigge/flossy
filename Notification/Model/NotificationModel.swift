//
//  Notification.swift
//  DidIFloss
//
//  Created by Lucas Migge on 09/01/24.
//

import Foundation
import UserNotifications

/// A model representing a basic notification for the Did I Floss app, utilizing the notification system.
///
/// You have the flexibility to create different types of notifications based on your specific needs. Feel free to experiment with various methods to craft engaging and humorous notifications for the user.
///
/// - Note: Provide a unique identifier for each notification type to manage removal from the schedule later on, if needed.
///
/// ## Example
///
/// There are various ways to create reminder types within Did I Floss. Here's an example of creating a short notification:
///
/// ```swift
/// struct FlossReminderNotification {
///     static let shortNotification = NotificationModel(id: "FlossReminderShortNotification",
///         titleMessage: "Are you 5 years old?",
///         bodyMessage:  "Will you let all your teeth rot? Go floss right now!",
///         timerInSeconds: 172800,
///         shouldRepeat: false)
/// }
/// ```
public struct NotificationModel {
    
    /// A unique identifier for the notification type.
    ///
    /// - Important: Used for removal from the notification schedule.
    public let id: String
    
    /// The primary message displayed in the notification.
    ///
    /// - Note: Prefer a concise string.
    public let titleMessage: String
    
    /// The main description of the notification.
    public let bodyMessage: String
    
    /// An optional secondary message for the notification.
    ///
    /// - Note: This is optional; you may choose not to provide this value.
    public var subTitle: String?
    
    public var trigger: UNNotificationTrigger
    
    /// The sound associated with the notification when displayed.
    ///
    /// - Note: Default options should be suitable for most use cases.
    public var sound: UNNotificationSound = .default
    
    
    /// Initializes a notification with a time interval specified in seconds.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for the notification type.
    ///   - titleMessage: The primary message displayed in the notification. Prefer a concise string.
    ///   - bodyMessage: The main description of the notification.
    ///   - subTitle: An optional secondary message for the notification.
    ///   - sound: The sound associated with the notification when displayed.
    ///
    /// - Note: Provide a unique identifier for each notification to manage removal from the schedule later on.
    public init(id: String, titleMessage: String, bodyMessage: String, subTitle: String? = nil, trigger: UNNotificationTrigger, sound: UNNotificationSound = .default) {
        self.id = id
        self.titleMessage = titleMessage
        self.bodyMessage = bodyMessage
        self.subTitle = subTitle
        self.trigger = trigger
        self.sound = sound
    }
    

    
    /// Builds a `UNNotificationContent` object based on the model information.
    ///
    /// - Returns: A `UNNotificationContent` object.
    internal var content: UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = titleMessage
        content.body = bodyMessage
        content.sound = sound
        
        if let safeSubTitle = subTitle {
            content.subtitle = safeSubTitle
        }
        
        return content
    }
}
