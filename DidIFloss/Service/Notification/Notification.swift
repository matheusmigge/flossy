//
//  Notification.swift
//  DidIFloss
//
//  Created by Lucas Migge on 08/01/24.
//

import Foundation
import UserNotifications

enum Notification: Identifiable {
    
    case twoDays
    case oneWeek
    case twoWeek
    
    var id: String {
        switch self {
        case .twoDays:
            return "twoDaysInactivityNotification"
        case .oneWeek:
            return "oneWeekInactivityNotification"
        case .twoWeek:
            return "twoWeekInactivityNotification"
        }
    }
    
    var title: String {
        switch self {
        case .twoDays:
            return "Don't lose track! 🦷"
        case .oneWeek:
            return "It's been a week... 🗓️"
        case .twoWeek:
            return "Hey Stranger... 🫂"
        }
        
    }
    
    var body: String {
        switch self {
        case .twoDays:
            return "You are doing great! Don't forget to floss today and register it"
        case .oneWeek:
            return "We are missing you! How about we floss today? "
        case .twoWeek:
            return "We can help you with your oral hygiene. Let's floss those teeth!"
        }
    }
    
    var timeInterval: TimeInterval {
        // in seconds
        switch self {
        case .twoDays:
            return 172800
        case .oneWeek:
            return 604800
        case .twoWeek:
            return 1209600
        }
    }
    
    var repeats: Bool {
        switch self {
        case .twoDays:
            return false
        case .oneWeek:
            return false
        case .twoWeek:
            return true
        }
    }
    
    var sound: UNNotificationSound {
        switch self {
        case .twoDays:
            return .default
        case .oneWeek:
            return .default
        case .twoWeek:
            return .default
        }
    }
    
}
