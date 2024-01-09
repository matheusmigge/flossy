//
//  Notification.swift
//  DidIFloss
//
//  Created by Lucas Migge on 09/01/24.
//

import Foundation
import UserNotifications

protocol NotificationModel {
    var id: String { get }
    var titleMessage: String { get }
    var bodyMessage: String { get }
    var subTitle: String? { get }
    var timeInterval: TimeInterval { get }
    var shouldRepeat: Bool { get }
    var sound: UNNotificationSound { get }
    
}

extension NotificationModel {
    var content: UNNotificationContent {
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
