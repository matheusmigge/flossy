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
            
            let content = DailyStreakReminder.getStandardMessageContent(daysOnStreak: days)
            
            return NotificationModel(id: notificationId,
                                     titleMessage: content.title,
                                     bodyMessage: content.body,
                                     trigger: UNNotificationTrigger.tomorrowAtNight())
        }
    }
}

extension FlossReminder.DailyStreakReminder {
    
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
            return MessageContent(title: "Wow! \(days) day streak! 🔥",
                                  body: "Keep up the excellent work!")
        } else {
            return MessageContent(title: "Don't stop now! ⏳",
                                  body: "You are \(days) day streak. Floss today to keep your streak growing")
        }
        
    }
    
    
    
    public static func getStandardMessageContent(daysOnStreak days: Int) -> MessageContent {
        
        let hasNotificationExplicitStreak: Bool = true
        
        if hasNotificationExplicitStreak {
            return standardExplicitStreakCatalog(daysOnStreak: days)
        } else {
            return standardStreakCatalog.randomElement() ?? MessageContent(title: "Keep up the good work! 🌟",
                                                                           body: "You've flossed days in a row. Keep the streak alive!")
        }
    }
}



