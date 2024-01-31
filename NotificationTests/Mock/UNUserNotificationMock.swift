//
//  UNUserNotificationMock.swift
//  NotificationTests
//
//  Created by Lucas Migge on 29/01/24.
//

import UserNotifications
@testable import Notification

class UNUserNotificationCenterMock: UNUserNotificationCenterable {
    
    var hasAuthorization: Bool = true
    var didCallAddNotification: Bool = false
    var didCallRequestAuth: Bool = false
    var didAskToRemoveRequestOfIdentifiers: [String] = []
    var scheduledNotificationIds: [String] = []
    
    
    func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Void)?) {
        didCallAddNotification = true
        
        if hasAuthorization {
            scheduledNotificationIds.append(request.identifier)
        } else {
            completionHandler?(NSError() as Error)
        }
        
    }
    
    func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void) {
        didCallRequestAuth = true
    }
    
    
    
    func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
        didAskToRemoveRequestOfIdentifiers = identifiers
        
        
    }
    
    func getPendingNotificationRequests(completionHandler: @escaping ([UNNotificationRequest]) -> Void) {
        
    }
    
    func removeAllPendingNotificationRequests() {
        scheduledNotificationIds.removeAll()
    }
}
