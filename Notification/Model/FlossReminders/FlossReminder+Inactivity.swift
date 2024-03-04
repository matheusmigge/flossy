//
//  FlossReminder+Inactivity.swift
//  Notification
//
//  Created by Lucas Migge on 07/02/24.
//

import Foundation
import UserNotifications


extension FlossReminder {
    
    struct Inactivity {
        enum Period: String, Identifiable, CaseIterable {
            case threeDays
            case fiveDays
            
            var id: String { self.rawValue + "InactivityNotification" }
        }
        
        
        static func createInactivityNotification(period: Period) -> NotificationModel {
            switch period {
            case .threeDays:
                
                let messageContent = self.getInvitationToStartMessageContent()
                
                return NotificationModel(
                    id: period.id,
                    titleMessage: messageContent.title,
                    bodyMessage:  messageContent.body,
                    trigger: UNNotificationTrigger.afterDays(days: 3)
                )
            case .fiveDays:
                
                let messageContent = self.getInactivityMessageContent()
                
                return NotificationModel(
                    id: period.id,
                    titleMessage: messageContent.title,
                    bodyMessage:  messageContent.body,
                    trigger: UNNotificationTrigger.afterDays(days: 5, repeats: true)
                )
            }
        }
        
        
        private static var inactivityMessageContent: [MessageContent] {
            [
                MessageContent(title: "We miss you! 🦷", body: "When was the last day you floss? What about we make it today?"),
                MessageContent(title: "Hey Stranger... 🫂", body: "We can help you with your oral hygiene. Let's floss those teeth!")
            ]
        }
        
        private static func getInactivityMessageContent() -> MessageContent {
            inactivityMessageContent.randomElement() ??  MessageContent(title: "We miss you! 🦷", body: "When was the last day you floss? What about we make it today?")
        }
        
        private static var invitationToStartMessageContent: [MessageContent] {
            [
                MessageContent(title: "Let's start the streak! 💪",
                               body: "Start your flossing streak today. Remember, consistency is key!"),
                MessageContent(title: "Begin your flossing journey today! 🚀",
                               body: "A journey of a thousand miles begins with a single step. Start flossing today!"),
                MessageContent(title: "Time to make a change! ⏰",
                               body: "Commit to better oral hygiene today. Start your flossing streak now!")
            ]
        }
        
        public static func getInvitationToStartMessageContent() -> MessageContent {
            return invitationToStartMessageContent.randomElement() ?? MessageContent(title: "Let's start the streak! 💪",
                                                                                     body: "Start your flossing streak today. Remember, consistency is key!")
        }
    }
}
