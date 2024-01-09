//
//  Notification.swift
//  DidIFloss
//
//  Created by Lucas Migge on 09/01/24.
//

import Foundation
import UserNotifications


struct NotificationModel {
    let id: String
    var titleMessage: String
    var bodyMessage: String
    var subTitle: String?
    var timeInterval: TimeInterval
    var shouldRepeat: Bool
    var sound: UNNotificationSound = .default
    
    
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
