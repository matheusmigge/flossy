//
//  AddFlossViewModelTests.swift
//  DidIFlossTests
//

import XCTest
@testable import DidIFloss

final class AddFlossViewModelTests: XCTestCase {
    
    class MockAddFlossDelegate: AddFlossDelegate {
        var didCallAddLogRecord = false
        var passedDate: Date?
        
        func addLogRecord(date: Date) {
            didCallAddLogRecord = true
            passedDate = date
        }
    }
    
    func test_isSelectedDateValid_whenDateIsInTheFuture_returnsFalse() {
        let sut = AddFlossViewModel()
        sut.selectedDate = Date().addingTimeInterval(3600) // 1 hour in the future
        
        XCTAssertFalse(sut.isSelectedDateValid)
    }
    
    func test_isSelectedDateValid_whenDateIsInThePast_returnsTrue() {
        let sut = AddFlossViewModel()
        sut.selectedDate = Date().addingTimeInterval(-3600) // 1 hour in the past
        
        XCTAssertTrue(sut.isSelectedDateValid)
    }
    
    func test_addLogRecord_whenDateIsValid_callsDelegate() {
        let mockDelegate = MockAddFlossDelegate()
        let sut = AddFlossViewModel(delegate: mockDelegate)
        let pastDate = Date().addingTimeInterval(-3600)
        
        sut.selectedDate = pastDate
        sut.addLogRecord()
        
        XCTAssertTrue(mockDelegate.didCallAddLogRecord)
        XCTAssertEqual(mockDelegate.passedDate, pastDate)
    }
    
    func test_addLogRecord_whenDateIsInvalid_doesNotCallDelegate() {
        let mockDelegate = MockAddFlossDelegate()
        let sut = AddFlossViewModel(delegate: mockDelegate)
        let futureDate = Date().addingTimeInterval(3600)
        
        sut.selectedDate = futureDate
        sut.addLogRecord()
        
        XCTAssertFalse(mockDelegate.didCallAddLogRecord)
        XCTAssertNil(mockDelegate.passedDate)
    }
}
