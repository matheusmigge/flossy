//
//  UNUserNotificationMock.swift
//  NotificationTests
//
//  Created by Lucas Migge on 29/01/24.
//

import UserNotifications
@testable import Notification

class UNUserNoticationCenterMock: UNUserNoticationCenterable {
    
    var didCallAddNotification: Bool = false
    
    func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Void)?) {
        didCallAddNotification = true
    }
    
    func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void) {
        
    }
    
    func getNotificationSettings(completionHandler: @escaping (UNNotificationSettings) -> Void) {
        
    }
    
    func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
        
    }
    
    func getPendingNotificationRequests(completionHandler: @escaping ([UNNotificationRequest]) -> Void) {
        
    }
    
    func removeAllPendingNotificationRequests() {
        
    }
}
