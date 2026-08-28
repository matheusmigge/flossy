import Testing
import Foundation
@testable import DidIFloss
import FlossyData

@Suite("AddLogRecordUseCase Tests")
struct AddLogRecordUseCaseTests {
    
    @Test("isDateValid returns false for future dates")
    func isDateValidFuture() {
        let sut = AddLogRecordUseCase()
        let futureDate = Date().addingTimeInterval(3600)
        
        #expect(sut.isDateValid(futureDate) == false)
    }
    
    @Test("isDateValid returns true for past dates")
    func isDateValidPast() {
        let sut = AddLogRecordUseCase()
        let pastDate = Date().addingTimeInterval(-3600)
        
        #expect(sut.isDateValid(pastDate) == true)
    }
    
    @Test("execute throws dateInFuture error for future dates")
    func executeThrowsForFutureDate() async {
        let sut = AddLogRecordUseCase()
        let futureDate = Date().addingTimeInterval(3600)
        
        do {
            try await sut.execute(date: futureDate)
            Issue.record("Expected dateInFuture error to be thrown")
        } catch let error as AddLogError {
            #expect(error == .dateInFuture)
        } catch {
            Issue.record("Expected AddLogError.dateInFuture, got \(error)")
        }
    }
    
    @Test("execute saves log and schedules notifications for valid dates")
    func executeValidDate() async throws {
        let mockRepo = FlossLogRepositoryMock()
        let mockNotificationService = NotificationManagerMock()
        let mockHaptics = HapticsManagerMock()
        
        let sut = AddLogRecordUseCase(
            recordsRepository: mockRepo,
            notificationService: mockNotificationService,
            hapticsManager: mockHaptics
        )
        
        let pastDate = Date().addingTimeInterval(-3600)
        
        try await sut.execute(date: pastDate)
        
        #expect(mockRepo.didCallAddLog == true)
        #expect(mockHaptics.didCallVibrateCelebration == true)
    }
}
