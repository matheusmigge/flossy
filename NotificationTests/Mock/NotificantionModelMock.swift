//
//  NotificationModelMock.swift
//  NotificationTests
//
//  Created by Lucas Migge on 29/01/24.
//

import Foundation
import UserNotifications
@testable import Notification


extension NotificationModel {
    static var example: NotificationModel {
        NotificationModel(id: "test", titleMessage: "testTitle", bodyMessage: "testMessage", trigger: UNNotificationTrigger.afterDays(days: 2))
    }
    
    static var exampleRequest: UNNotificationRequest {
        let notification = Self.example
        return UNNotificationRequest(identifier: notification.id, content: notification.content, trigger: notification.trigger)

    }
}

