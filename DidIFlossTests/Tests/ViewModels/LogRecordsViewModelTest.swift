//
//  LogRecordsViewModelTest.swift
//  DidIFlossTests
//
//  Created by Lucas Migge on 07/03/24.
//

import XCTest
@testable import DidIFloss

final class LogRecordsViewModelTest: XCTestCase {
    
    var viewModel: LogRecordsViewModel!
    
    var persistenceMock: PersistenceManagerMock!
    var notificationMock: NotificationManagerMock!
    var hapticsMock: HapticsManagerMock!
    var logHandler: HandleLogInteractionUseCaseMock!
    var flossDataProvider: FlossRecordDataProviderMock!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        flossDataProvider = FlossRecordDataProviderMock()
        
        persistenceMock = PersistenceManagerMock()
        hapticsMock = HapticsManagerMock()
        logHandler = HandleLogInteractionUseCaseMock()
        
        
        viewModel = LogRecordsViewModel(
            persistenceService: persistenceMock,
            userFeedbackService: hapticsMock,
            logRecordsHandler: logHandler)
    }
    
    func testViewDidAppearsCallsDataFromRepository() {
        
        persistenceMock.didCallGetFlossRecord = false
        
        viewModel.viewDidApper()
        
        XCTAssertTrue(persistenceMock.didCallGetFlossRecord)
        
    }
    
    func testRemoveRecordAtCallsCorrespondingMethodFromUserCase() {
        
        let log1 = FlossRecord(date: .distantPast)
        let log2 = FlossRecord(date: .now)
        viewModel.records = [log1, log2]
        logHandler.didCallRemoveLogRecord = false
        hapticsMock.didCallVibrateRemoval = false
        
        viewModel.removeRecordAt(indexSet: IndexSet(integer: 1))
        
        XCTAssertTrue(logHandler.didCallRemoveLogRecord)
        XCTAssertTrue(hapticsMock.didCallVibrateRemoval)
        
    }
    
    func testRemoveRecordCallsCorrespondingMethodFromUseCase() {
        
        let log1 = FlossRecord(date: .distantPast)
        let log2 = FlossRecord(date: .now)
        viewModel.records = [log1, log2]
        logHandler.didCallRemoveLogRecord = false
        hapticsMock.didCallVibrateRemoval = false
        
        viewModel.removeRecord(log2)
        
        XCTAssertTrue(logHandler.didCallRemoveLogRecord)
        XCTAssertTrue(hapticsMock.didCallVibrateRemoval)
        
    }
    
    func testDidSelectDateAddsValueToViewModelVariableIfEmpty() {
        
        viewModel.selectedDate = nil
        
        viewModel.didSelectDate(.now)
        
        XCTAssertNotNil(viewModel.selectedDate)
        
    }
    
    func testDidSelectDateRemoveValuesIfNotNil() {
        
        viewModel.selectedDate = .distantFuture
        
        viewModel.didSelectDate(.now)
        
        XCTAssertNotNil(viewModel.selectedDate)
        
    }
    
    func testSectionRecordsShouldNotChangeIfSelectedDateIsNil() {
        
        let log1 = FlossRecord(date: .distantPast)
        let log2 = FlossRecord(date: .now)
        let log3 = FlossRecord(date: .now)
        viewModel.records = [log1, log2, log3]
        
        viewModel.selectedDate = .now
        
        XCTAssertFalse(viewModel.sectionRecords.contains(log1))
        XCTAssertTrue(viewModel.sectionRecords.contains([log3, log2]))
        
    }
    
    func testSectionRecordsShouldBeFilteredBasedBySelectedDateIfHasOne() {
        
        let log1 = FlossRecord(date: .distantPast)
        let log2 = FlossRecord(date: .now)
        let log3 = FlossRecord(date: .now)
        viewModel.records = [log1, log2, log3]
        
        viewModel.selectedDate = nil
        
        XCTAssertTrue(viewModel.sectionRecords.contains([log3, log2, log1]))
        
    }
    
}
