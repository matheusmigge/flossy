//
//  Notification.swift
//  DidIFloss
//
//  Created by Lucas Migge on 08/01/24.
//

import Foundation
import UserNotifications

extension Notification {
    struct FlossReminder: NotificationModel {
        let id: String
        let titleMessage: String
        var subTitle: String?
        let bodyMessage: String
        let timeInterval: TimeInterval
        let shouldRepeat: Bool
        let sound: UNNotificationSound = .default
        
        static func getAllNotifications() -> [FlossReminder] {
            return [.twoDays, .oneWeek, .twoWeek]
        }

        static let twoDays = FlossReminder(
            id: "twoDaysInactivityNotification",
            titleMessage: "Don't lose track! 🦷",
            bodyMessage: "You are doing great! Don't forget to floss today and register it",
            timeInterval: 172800,
            shouldRepeat: false
        )

        static let oneWeek = FlossReminder(
            id: "oneWeekInactivityNotification",
            titleMessage: "It's been a week... 🗓️",
            bodyMessage: "We are missing you! How about we floss today?",
            timeInterval: 604800,
            shouldRepeat: false
        )

        static let twoWeek = FlossReminder(
            id: "twoWeekInactivityNotification",
            titleMessage: "Hey Stranger... 🫂",
            bodyMessage: "We can help you with your oral hygiene. Let's floss those teeth!",
            timeInterval: 1209600,
            shouldRepeat: true
        )
    }

}
