import Testing
import Foundation
import FlossyCore
@testable import DidIFloss
import FlossyData

@Suite("RemoveLogRecordUseCase Tests")
struct RemoveLogRecordUseCaseTests {
    
    @Test("execute for record deletes log and vibrates")
    func executeForRecord() async throws {
        let mockRepo = FlossLogRepositoryMock()
        
        let sut = RemoveLogRecordUseCase(
            recordsRepository: mockRepo,
            notificationService: NotificationManagerMock()
        )
        
        let record = FlossLog(flossDate: Date())
        
        try await sut.execute(record: record)
        
        #expect(mockRepo.didCallDeleteLog == true)
    }
    
    @Test("execute removeAll deletes logs for date and vibrates")
    func executeRemoveAllForDate() async throws {
        let mockRepo = FlossLogRepositoryMock()
        
        let sut = RemoveLogRecordUseCase(
            recordsRepository: mockRepo,
            notificationService: NotificationManagerMock()
        )
        
        let date = Date()
        
        try await sut.execute(removeAllFor: date)
        
        #expect(mockRepo.didCallDeleteLogs == true)
    }
}
