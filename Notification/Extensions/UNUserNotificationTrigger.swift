//
//  UNUserNotificationTrigger.swift
//  Notification
//
//  Created by Lucas Migge on 07/02/24.
//

import Foundation
import UserNotifications

extension UNNotificationTrigger {
    static func tomorrowAtNight() -> UNCalendarNotificationTrigger {
        let triggerDay = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        var triggerDate = Calendar.current.dateComponents([.day, .minute], from: triggerDay)
        
        // trigger any hour at night
        triggerDate.hour = Int.random(in: 18...22)
        
        return UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
    }
      
      static func afterDays(days: Int, repeats: Bool = false) -> UNCalendarNotificationTrigger {
          let triggerDay = Calendar.current.date(byAdding: .day, value: days, to: Date())!
          var triggerDate = Calendar.current.dateComponents([.day, .minute], from: triggerDay)
          
          // trigger any hour at night
          triggerDate.hour = Int.random(in: 10...20)
          
          return UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: repeats)
      }
}
