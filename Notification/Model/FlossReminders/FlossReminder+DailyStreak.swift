//
//  FlossReminder+DailyStreak.swift
//  Notification
//
//  Created by Lucas Migge on 07/02/24.
//

import Foundation
import UserNotifications

extension FlossReminder {
    
    struct DailyStreakReminder {
        static let notificationId: String = "dailyStreakNotification"
        
        static func createDailyStreakReminderModel(daysOnStreak days: Int) -> NotificationModel {
            
            var content: MessageContent
            
            if days < 2 {
                content = MessageContent.getSmallStreakMessageContent()
            } else {
                content = MessageContent.getStandardMessageContent(daysOnStreak: days)
            }
            
            return NotificationModel(id: notificationId,
                                     titleMessage: content.title,
                                     bodyMessage: content.body,
                                     trigger: UNNotificationTrigger.tomorrowAtNight())
        }
    }
}

extension FlossReminder.DailyStreakReminder {
    
    struct MessageContent {
        var title: String
        var body: String
        
        private static var smallStreaksCatalog: [MessageContent] {
            [
                MessageContent(title: "Let's start the streak! 💪",
                               body: "Start your flossing streak today. Remember, consistency is key!"),
                MessageContent(title: "Begin your flossing journey today! 🚀",
                               body: "A journey of a thousand miles begins with a single step. Start flossing today!"),
                MessageContent(title: "Time to make a change! ⏰",
                               body: "Commit to better oral hygiene today. Start your flossing streak now!")
            ]
        }
        
        private static var standardStreakCatalog: [MessageContent] {
            [
                MessageContent(title: "Keep up the good work! 🌟",
                               body: "You've flossed days in a row. Keep the streak alive!"),
                MessageContent(title: "Stay consistent! 💪",
                               body: "Consistency is the key to success. Keep flossing every day!"),
                MessageContent(title: "You're doing great! 👍",
                               body: "Your commitment to flossing is admirable. Keep up the excellent work!"),
                MessageContent(title: "Great job! 🦷",
                               body: "You're making a positive impact on your oral health with each flossing session. Keep it up!"),
                MessageContent(title: "Way to go! 🎉",
                               body: "Your dedication to flossing is paying off. Keep the streak alive and your smile bright!"),
                MessageContent(title: "You're on fire! 🔥",
                               body: "Your consistency in flossing is remarkable. Keep the momentum going!"),
                MessageContent(title: "Don't stop now! ⏳",
                               body: "You're on a path to healthier teeth and gums. Keep flossing every day to maintain the streak!"),
                MessageContent(title: "One step at a time! 👣",
                               body: "Every flossing session brings you closer to better oral health. Keep taking those steps!"),
                MessageContent(title: "Consistency pays off! 💰",
                               body: "Your commitment to flossing is an investment in your oral health. Keep up the good work!"),
                MessageContent(title: "Keep that smile shining! 😁",
                               body: "Your dedication to flossing ensures that your smile remains bright and healthy. Keep it up!"),
            ]
        }
        
        private static func standardExplicitStreakCatalog(daysOnStreak days: Int) -> MessageContent {
            
            let explicitContentOnTitle: Bool = Bool.random()
            
            if explicitContentOnTitle {
                return MessageContent(title: "Wow! \(days) days in a streak! 🔥",
                                      body: "Keep up the excellent work!")
            } else {
                return MessageContent(title: "Don't stop now! ⏳",
                                      body: "You are \(days) days on streak. Floss today to keep your streak growing")
            }
            
        }
        
        public static func getSmallStreakMessageContent() -> MessageContent {
            return smallStreaksCatalog.randomElement() ?? MessageContent(title: "Let's start the streak! 💪",
                                                                         body: "Start your flossing streak today. Remember, consistency is key!")
        }
        
        public static func getStandardMessageContent(daysOnStreak days: Int) -> MessageContent {
            
            let hasNotificationExplicitStreak: Bool = Bool.random()
            
            if hasNotificationExplicitStreak {
                return standardExplicitStreakCatalog(daysOnStreak: days)
            } else {
                return standardStreakCatalog.randomElement() ?? MessageContent(title: "Keep up the good work! 🌟",
                                                                               body: "You've flossed days in a row. Keep the streak alive!")
            }
        }
    }
    
}
