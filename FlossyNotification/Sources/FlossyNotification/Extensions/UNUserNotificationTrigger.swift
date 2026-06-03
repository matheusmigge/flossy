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
        
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        var triggerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: tomorrow)
        
        // trigger any hour at night
        triggerComponents.hour = Int.random(in: 18...20)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
        
        return trigger
    }
      
      static func afterDays(days: Int, repeats: Bool = false) -> UNCalendarNotificationTrigger {
          let triggerDay = Calendar.current.date(byAdding: .day, value: days, to: Date())!
          var triggerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDay)
          
          // trigger any hour of the day
          triggerComponents.hour = Int.random(in: 10...20)
          
          let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
          
          return trigger
      }
}
