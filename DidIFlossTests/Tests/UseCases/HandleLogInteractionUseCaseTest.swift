//
//  HandleLogInteractionUseCaseTest.swift
//  DidIFlossTests
//
//  Created by Lucas Migge on 29/03/24.
//

import XCTest
@testable import DidIFloss

class HandleLogInteractionUseCaseTest: XCTestCase {
    
    var useCase: HandleLogInteractionUseCase!
    
    var persistenceService: PersistenceManagerMock!
    var notificationService: NotificationManagerMock!
    var flossDataProvider: FlossRecordDataProviderMock!
    
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        flossDataProvider = FlossRecordDataProviderMock()
        
        persistenceService = PersistenceManagerMock()
        notificationService = NotificationManagerMock()
        
        useCase = HandleLogInteractionUseCase(recordsRepository: persistenceService, notificationService: notificationService)
    }
    
    func testHandleLogRecordFormatsDateIfLogIsNotTodayAndCallsPersistencyDependency() {
        persistenceService.didCallSaveFlossRecordForDate = nil
        
        
        let date = Calendar.createDate(year: 2024, month: 01, day: 01, hour: 0, minute: 0)!
        useCase.handleLogRecord(for: date)
        
        
        let flossDateSaved: Date? = persistenceService.didCallSaveFlossRecordForDate
        XCTAssertNotNil(flossDateSaved)
        XCTAssertTrue(Calendar.current.isDate(date, inSameDayAs: flossDateSaved!), "After formating, the date should still be same day")
        XCTAssertTrue(date != flossDateSaved, "Should only update time components")
        
    }
    
    func testHandleLogRecordDontFormatsDateIfLogIsTodayAndCallsPersistencyDependency() {
        persistenceService.didCallSaveFlossRecordForDate = nil
        
        
        let date: Date = .now
        useCase.handleLogRecord(for: date)
        
        
        let flossDateSaved: Date? = persistenceService.didCallSaveFlossRecordForDate
        XCTAssertNotNil(flossDateSaved)
        XCTAssertTrue(date == flossDateSaved, "date should not be changed")
        
        
    }
    
    func testHandleLogRecordCallsScheduleNotificationWithExpectedInfoIfLogIsToday() {
        
        notificationService.didScheduleAllNotifications = false
        
        
        
        let date: Date = .now
         useCase.handleLogRecord(for: date)
        
        
        XCTAssertTrue(    notificationService.didScheduleAllNotifications)
    
        
    }
    
    func testHandleLogRecordCallsOnlyInactivityNotificationIfLogIsNotToday() {
        
        notificationService.didScheduleAllNotifications = false
        
        
        
        let date: Date = .distantPast
        useCase.handleLogRecord(for: date)
        
        
        XCTAssertFalse(    notificationService.didScheduleAllNotifications)
        XCTAssertTrue(notificationService.didScheduleInactivityNotification)
        
    }

    func testRemoveLogRecordCallsPersistenceDependency() {
        persistenceService.didCallRemoveFlossRecordOn = nil
        let log = FlossRecord(date: .now)
        
        useCase.removeLogRecord(for: log)
        

        XCTAssertNotNil(persistenceService.didCallRemoveFlossRecordOn, "method should call related persistence dependency")
        XCTAssertEqual(log, persistenceService.didCallRemoveFlossRecordOn)
        
    }
    
    func testRemoveLogRecordDontCallsRemoveDailyNotificationIfStillHasLogForToday() {
        notificationService.didRemovePendingDailyNotification = false
        let log1 = FlossRecord(date: .now)
        let log2 = FlossRecord(date: .now)
        persistenceService.logs = [log1, log2]
        
        useCase.removeLogRecord(for: log1)
        
        XCTAssertFalse(notificationService.didRemovePendingDailyNotification)
        
    }
    
    func testRemoveLogRecordCallsRemoveDailyNotificationIfHasNoRecordForToday() {
        notificationService.didRemovePendingDailyNotification = false
        let log1 = FlossRecord(date: .now)
        let log2 = FlossRecord(date: .distantPast)
        persistenceService.logs = [log1, log2]
        
        useCase.removeLogRecord(for: log1)
        
        XCTAssertTrue(notificationService.didRemovePendingDailyNotification)
        
    }
    
    func testRemoveLogRecordDontCallsRemoveDailyNotificationIfLogIsNotToday() {
        
        notificationService.didRemovePendingDailyNotification = false
        let log1 = FlossRecord(date: .now)
        let log2 = FlossRecord(date: .distantPast)
        persistenceService.logs = [log1, log2]
        
        useCase.removeLogRecord(for: log2)
        
        XCTAssertFalse(notificationService.didRemovePendingDailyNotification)
        
    }
    
    
    func testRemoveAllLogsRecordsCallsDependencyForEachLog() {
        let log1 = FlossRecord(date: .now)
        let log2 = FlossRecord(date: .now)
        let log3 = FlossRecord(date: .distantPast)
        persistenceService.logs = [log1, log2, log3]
        persistenceService.didCallRemoveAllFlossRecordsOn = []

        
        useCase.removeAllLogRecords(for: .now)
        
        let expectedResult = persistenceService.didCallRemoveAllFlossRecordsOn
        XCTAssertEqual([log1, log2], expectedResult)
        
    }
    
    func testRemoveAllLogsRecordsCallsRemovesDailyNotificationIfLogIsToday() {
        
        notificationService.didRemovePendingDailyNotification = false
        let log1 = FlossRecord(date: .now)
        let log2 = FlossRecord(date: .now)
        let log3 = FlossRecord(date: .distantPast)
        persistenceService.logs = [log1, log2, log3]
        
        useCase.removeAllLogRecords(for: .now)
        

        XCTAssertTrue(notificationService.didRemovePendingDailyNotification)
        
        
    }
    
    func testRemoveAllLogsRecordsCallsDontRemovesDailyNotificationIfLogIsNotToday() {
        
        notificationService.didRemovePendingDailyNotification = false
        let log1 = FlossRecord(date: .now)
        let log2 = FlossRecord(date: .now)
        let log3 = FlossRecord(date: .distantPast)
        persistenceService.logs = [log1, log2, log3]
        
        useCase.removeAllLogRecords(for: .distantPast)
        

        XCTAssertFalse(notificationService.didRemovePendingDailyNotification)
        
    }
    
    
    
}
