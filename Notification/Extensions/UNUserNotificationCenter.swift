//
//  UNUserNotificationCenter.swift
//  Notification
//
//  Created by Lucas Migge on 29/01/24.
//

import Foundation
import UserNotifications

protocol UNUserNotificationCenterable {
    func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void)
    
    func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Void)?)
    
    func getPendingNotificationRequests(completionHandler: @escaping ([UNNotificationRequest]) -> Void)
    
    func removePendingNotificationRequests(withIdentifiers identifiers: [String])
    
    func removeAllPendingNotificationRequests()
        
}

extension UNUserNotificationCenter: UNUserNotificationCenterable {
    
}
