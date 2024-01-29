//
//  UNUserNotificationCenter.swift
//  Notification
//
//  Created by Lucas Migge on 29/01/24.
//

import Foundation
import UserNotifications

protocol UNUserNoticationCenterable {
    func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void)
    
    func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Void)?)
    
    func getNotificationSettings(completionHandler: @escaping (UNNotificationSettings) -> Void)
    
    func getPendingNotificationRequests(completionHandler: @escaping ([UNNotificationRequest]) -> Void)
    
    func removePendingNotificationRequests(withIdentifiers identifiers: [String])
    
    func removeAllPendingNotificationRequests()
    
}

extension UNUserNotificationCenter: UNUserNoticationCenterable {
    
}
