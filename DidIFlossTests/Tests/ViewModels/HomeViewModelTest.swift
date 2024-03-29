//
//  HomeViewModelTest.swift
//  DidIFlossTests
//
//  Created by Lucas Migge on 07/03/24.
//

import XCTest
@testable import DidIFloss

final class HomeViewModelTest: XCTestCase {
    
    var viewModel: HomeViewModel!
    
    var persistenceMock: PersistenceManagerMock!
    var notificationMock: NotificationManagerMock!
    var hapticsMock: HapticsManagerMock!
    var logHandler: HandleLogInteractionUseCaseMock!
    var flossDataProvider: FlossRecordDataProviderMock!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        flossDataProvider = FlossRecordDataProviderMock()
        
        persistenceMock = PersistenceManagerMock()
        notificationMock = NotificationManagerMock()
        hapticsMock = HapticsManagerMock()
        logHandler = HandleLogInteractionUseCaseMock()
        
        
        viewModel = HomeViewModel(persistence: persistenceMock,
                                  notificationService: notificationMock,
                                  userFeedbackService: hapticsMock,
                                  logInteractionHandler: logHandler)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
    }
    
    func testViewModelHasObserverAfterOnAppear() {
        persistenceMock.delegate = nil
        
        viewModel.viewDidApper()
        
        XCTAssertNotNil(persistenceMock.delegate, "❌ HomeViewModel needs to be updated if another class makes changes on the floss records database")
    }
    
    
    func testLoadsRecordsWhenViewAppears() {
        viewModel.flossRecords = []
        
        viewModel.viewDidApper()
        
        XCTAssertTrue(persistenceMock.didCallGetFlossRecord, "❌ HomeViewModel should fetch data when view appears")
        
    }
    
    func testShouldPresentOnboardingWhenNewUser() {
        persistenceMock.isNewUser = true
        
        viewModel.viewDidApper()
        
        // Expectation to fulfill after delay
        let expectation = XCTestExpectation(description: "sheetView set to welcomeSheet")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            XCTAssertEqual(self.viewModel.sheetView, .welcomeSheet)
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 3)
        
    }
    
    func testShouldNotPresentOnboardingIfNotNewUser() {
        persistenceMock.isNewUser = false
        
        viewModel.viewDidApper()
        
        // Expectation to fulfill after delay
        let expectation = XCTestExpectation(description: "sheetView set to welcomeSheet")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            XCTAssertNil(self.viewModel.sheetView, "ViewModel should not have any active sheet")
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 2)
    }
    
    func testShouldRequestNotificationAuthAfterOnboarding() {
        notificationMock.didCallRequestAuth = false
        
        viewModel.onboardingOver()
        
        XCTAssertTrue(notificationMock.didCallRequestAuth, "ViewModel Should ask for auth after Onboarding")
    }
    
    func testPlusButtonPressedShouldPresentAddLogSheet() {
        
        viewModel.plusButtonPressed()
        
        XCTAssertEqual(viewModel.sheetView, .addLogSheet)
        
    }
    
    func testPlusButtonShouldNotPresentSheetIfInCelebration() {
        viewModel.showingCelebration = true
        
        viewModel.plusButtonPressed()
        
        XCTAssertNil(viewModel.sheetView, "Add Log Sheet should not appear while in celebration")
        
        
    }
    
    func testAddLogSheetCallsDependencies() {
        logHandler.didCallHandleLogRecord = false
        persistenceMock.didCallGetFlossRecord = false
        hapticsMock.didCallVibrateCelebration = false
        viewModel.showingCelebration = false
        viewModel.sheetView = .addLogSheet
        
        
        viewModel.addLogRecord(date: .now)
        
        
        XCTAssertTrue(logHandler.didCallHandleLogRecord, "Method should call UseCase log Handler")
        XCTAssertTrue(hapticsMock.didCallVibrateCelebration, "Method should call haptics feedback")
        XCTAssertTrue(viewModel.showingCelebration, "Method should present celebration")
        XCTAssertNil(viewModel.sheetView, "Method should clear any sheet active")
        XCTAssertTrue(persistenceMock.didCallGetFlossRecord, "ViewModel should update after method action")
        
        
    }
    
    func testDidCompleteAnimationChangeStatusWhenAnimationIsOver() {
        viewModel.showingCelebration = true
        
        viewModel.didCompleteAnimation()
        
        XCTAssertFalse(viewModel.showingCelebration, "As a CelebrationDelegate, ViewModel should update it's status")
    }
    
    func testViewModelShouldUpdateWhenMonitorChangesCalled() {
        
        viewModel.viewDidApper()
        persistenceMock.didCallGetFlossRecord = false
        
        viewModel.hadChangesInFlossRecordDataBase()
        
        XCTAssertTrue(persistenceMock.didCallGetFlossRecord, "VM should call persistence and update its data")
        
    }
    
    func testDidSelectDateShouldUpdateFocusedDateAndPresentAlertWhenHasRecordForDate() {
        
        let log = FlossRecord(date: .now)
        viewModel.flossRecords = [log]
        viewModel.showingAlert = false
        viewModel.focusedDate = nil
        persistenceMock.didCallSaveFlossRecordForDate = nil
        
        viewModel.didSelectDate(.now)
        
        
        XCTAssertTrue(viewModel.showingAlert)
        XCTAssertNotNil(viewModel.focusedDate)
        XCTAssertNil(persistenceMock.didCallSaveFlossRecordForDate)
        
    }
    
    func testDidSelectDateShouldCallAddLogRecordsIfHasNoRecordsForDate() {
        
        viewModel.flossRecords = []
        viewModel.showingAlert = false
        viewModel.focusedDate = nil
        logHandler.didCallHandleLogRecord = false
        
        viewModel.didSelectDate(.now)
        
        
        XCTAssertFalse(viewModel.showingAlert)
        XCTAssertNil(viewModel.focusedDate)
        XCTAssertTrue(logHandler.didCallHandleLogRecord)
        
    
    }
    
    func testRemoveRecordsShouldCallPersistenceWhenHasDate() {
        
        viewModel.focusedDate = .now
        logHandler.didCallRemoveAllLogRecords = false
        hapticsMock.didCallVibrateRemoval = false
        
        
        viewModel.removeRecordsForFocusedDate()
        
        
        XCTAssertTrue(logHandler.didCallRemoveAllLogRecords)
        XCTAssertTrue(hapticsMock.didCallVibrateRemoval)
        
    }
    
}
