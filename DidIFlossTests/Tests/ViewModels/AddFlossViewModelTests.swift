//
//  AddFlossViewModelTests.swift
//  DidIFlossTests
//

import Testing
import Foundation
@testable import DidIFloss

@Suite("AddFlossViewModel Tests")
struct AddFlossViewModelTests {
    
    class MockAddFlossDelegate: AddFlossDelegate {
        var didCallAddLogRecord = false
        var passedDate: Date?
        
        func addLogRecord(date: Date) {
            didCallAddLogRecord = true
            passedDate = date
        }
    }
    
    @Test("isSelectedDateValid returns false when date is in the future")
    func testIsSelectedDateValidFuture() {
        let sut = AddFlossViewModel()
        sut.selectedDate = Date().addingTimeInterval(3600) // 1 hour in the future
        
        #expect(sut.isSelectedDateValid == false)
    }
    
    @Test("isSelectedDateValid returns true when date is in the past")
    func testIsSelectedDateValidPast() {
        let sut = AddFlossViewModel()
        sut.selectedDate = Date().addingTimeInterval(-3600) // 1 hour in the past
        
        #expect(sut.isSelectedDateValid == true)
    }
    
    @Test("addLogRecord calls delegate when date is valid")
    func testAddLogRecordValid() {
        let mockDelegate = MockAddFlossDelegate()
        let sut = AddFlossViewModel(delegate: mockDelegate)
        let pastDate = Date().addingTimeInterval(-3600)
        
        sut.selectedDate = pastDate
        sut.addLogRecord()
        
        #expect(mockDelegate.didCallAddLogRecord == true)
        #expect(mockDelegate.passedDate == pastDate)
    }
    
    @Test("addLogRecord does not call delegate when date is invalid")
    func testAddLogRecordInvalid() {
        let mockDelegate = MockAddFlossDelegate()
        let sut = AddFlossViewModel(delegate: mockDelegate)
        let futureDate = Date().addingTimeInterval(3600)
        
        sut.selectedDate = futureDate
        sut.addLogRecord()
        
        #expect(mockDelegate.didCallAddLogRecord == false)
        #expect(mockDelegate.passedDate == nil)
    }
}
