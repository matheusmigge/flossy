//
//  Notification.swift
//  DidIFloss
//
//  Created by Lucas Migge on 08/01/24.
//

import Foundation
import UserNotifications

extension Notification {
    
    struct FlossReminder {
        
        static func getAllNotifications() -> [NotificationModel] {
            return [self.twoDays, self.oneWeek, self.twoWeek]
        }
        
        
        static let twoDays = NotificationModel(id: "twoDaysInactivityNotification",
                                               titleMessage: "Don't lose track! 🦷",
                                               bodyMessage:  "You are doing great! Don't forget to floss today and register it",
                                               timeInterval: 172800,
                                               shouldRepeat: false
        )
        
        static let oneWeek = NotificationModel(id: "oneWeekInactivityNotification",
                                               titleMessage: "It's been a week... 🗓️",
                                               bodyMessage:  "We are missing you! How about we floss today?",
                                               timeInterval: 604800,
                                               shouldRepeat: false
        )
        
        static let twoWeek = NotificationModel(id: "twoWeekInactivityNotification",
                                               titleMessage: "Hey Stranger... 🫂",
                                               bodyMessage: "We can help you with your oral hygiene. Let's floss those teeth!",
                                               timeInterval: 1209600,
                                               shouldRepeat: true
        )
        
        
    }
    
}
