import Testing
import Foundation
@testable import DidIFloss
import FlossyData

@Suite("RemoveLogRecordUseCase Tests")
struct RemoveLogRecordUseCaseTests {
    
    @Test("execute for record deletes log and vibrates")
    func executeForRecord() async throws {
        let mockRepo = FlossLogRepositoryMock()
        let mockHaptics = HapticsManagerMock()
        
        let sut = RemoveLogRecordUseCase(
            recordsRepository: mockRepo,
            hapticsManager: mockHaptics
        )
        
        let record = FlossLog(flossDate: Date())
        
        try await sut.execute(record: record)
        
        #expect(mockRepo.didCallDeleteLog == true)
        #expect(mockHaptics.didCallVibrateRemoval == true)
    }
    
    @Test("execute removeAll deletes logs for date and vibrates")
    func executeRemoveAllForDate() async throws {
        let mockRepo = FlossLogRepositoryMock()
        let mockHaptics = HapticsManagerMock()
        
        let sut = RemoveLogRecordUseCase(
            recordsRepository: mockRepo,
            hapticsManager: mockHaptics
        )
        
        let date = Date()
        
        try await sut.execute(removeAllFor: date)
        
        #expect(mockRepo.didCallDeleteLogs == true)
        #expect(mockHaptics.didCallVibrateRemoval == true)
    }
}
