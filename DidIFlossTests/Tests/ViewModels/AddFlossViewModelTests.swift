import Testing
import Foundation
@testable import DidIFloss

@MainActor
@Suite("AddFlossViewModel Tests")
struct AddFlossViewModelTests {
    
    class HomeCoordinatorDelegateMock: HomeCoordinatorDelegate {
        var didTapAddLogButtonCallCount = 0
        func didTapAddLogButton() {}
        func didTapDeveloperOptions() {}
        func didTapShareStreak(streakMessage: String) {}
        func didTapLogRecords() {}
        func onboardingDidComplete() {}
        
        var addLogDidCompleteCallCount = 0
        func addLogDidComplete() {
            addLogDidCompleteCallCount += 1
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
    
    @Test("addLogRecord calls usecase and coordinator when date is valid")
    func testAddLogRecordValid() {
        let logHandlerMock = HandleLogInteractionUseCaseMock()
        let coordinatorMock = HomeCoordinatorDelegateMock()
        let sut = AddFlossViewModel(
            logRecordsHandler: logHandlerMock,
            coordinatorDelegate: coordinatorMock
        )
        let pastDate = Date().addingTimeInterval(-3600)
        
        sut.selectedDate = pastDate
        sut.addLogRecord()
        
        #expect(logHandlerMock.didCallHandleLogRecord == true)
        #expect(logHandlerMock.passedDate == pastDate)
        #expect(coordinatorMock.addLogDidCompleteCallCount == 1)
    }
    
    @Test("addLogRecord does not call usecase when date is invalid")
    func testAddLogRecordInvalid() {
        let logHandlerMock = HandleLogInteractionUseCaseMock()
        let coordinatorMock = HomeCoordinatorDelegateMock()
        let sut = AddFlossViewModel(
            logRecordsHandler: logHandlerMock,
            coordinatorDelegate: coordinatorMock
        )
        let futureDate = Date().addingTimeInterval(3600)
        
        sut.selectedDate = futureDate
        sut.addLogRecord()
        
        #expect(logHandlerMock.didCallHandleLogRecord == false)
        #expect(logHandlerMock.passedDate == nil)
        #expect(coordinatorMock.addLogDidCompleteCallCount == 0)
    }
}
