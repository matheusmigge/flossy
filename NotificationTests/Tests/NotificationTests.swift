//
//  NotificationTests.swift
//  NotificationTests
//
//  Created by Lucas Migge on 29/01/24.
//

import XCTest
@testable import Notification

final class NotificationTests: XCTestCase {
    
    var center: UNUserNotificationCenterMock!
    var notificationService: NotificationService!
    
    override func setUpWithError() throws {
        self.center = UNUserNotificationCenterMock()
        self.notificationService = NotificationService(center: center)
    }

    override func tearDownWithError() throws {

    }

    func testAddNotificationsCallsCenter() {
        center.hasAuthorization = true
        let notification = NotificationModel.example
        
        self.notificationService.scheduleNotification(type: notification)

        XCTAssertTrue(center.didCallAddNotification)
    }

    func testAddNotificationAppendsNotificationSchedule() {
        center.hasAuthorization = true
        center.scheduledNotificationIds = []
        let notification = NotificationModel.example
        
        self.notificationService.scheduleNotification(type: notification)

        XCTAssertFalse(center.scheduledNotificationIds.isEmpty)
    }
    
    
    func testRequestAuthCallsCenterRequestAuth() {
        center.didCallRequestAuth = false
        
        notificationService.requestAuthorizationToNotificate()
        
        XCTAssertTrue(center.didCallRequestAuth)
    }
    
    func testRemovePendingNotificationCallsCenterWithIdentifier() {
        let notificationIdentifier = "test"
        
        notificationService.center.removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
        
        XCTAssertTrue(center.didAskToRemoveRequestOfIdentifiers.contains(notificationIdentifier))
    }
    
    func testScheduleInactivityFlossRemindersAppendsToScheduleCenter() {
        let notificationsIds = FlossReminder.getAllInactivityReminderModels().map { $0.id }
        
        notificationService.scheduleInactivityFlossReminderNotifications()
        
        XCTAssertEqual(notificationsIds, center.scheduledNotificationIds)
    }
    
    
    func testRemoveAllPendingNotificationsSchedules() {
        let notificationIds = ["test1", "test2", "test3"]
        center.scheduledNotificationIds = notificationIds
        
        notificationService.clearAllPendingNotifications()
        
        XCTAssertTrue(center.scheduledNotificationIds.isEmpty)
    }
    
}
