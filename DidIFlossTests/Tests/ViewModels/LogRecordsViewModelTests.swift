import Testing
import Foundation
@testable import DidIFloss
import FlossyData

@MainActor
@Suite("LogRecordsViewModel Tests")
struct LogRecordsViewModelTests {
    
    @Test("removeRecord calls usecase execute")
    func removeRecordCallsUseCase() async {
        let removeUseCaseMock = RemoveLogRecordUseCaseMock()
        let sut = LogRecordsViewModel(
            recordsRepository: FlossLogRepositoryMock(),
            removeLogRecordUseCase: removeUseCaseMock
        )
        
        let record = FlossLog(flossDate: Date())
        
        await sut.removeRecord(record)
        
        #expect(removeUseCaseMock.didCallExecuteRecord == true)
        #expect(removeUseCaseMock.passedRecord?.id == record.id)
    }
    
    @Test("removeRecordAt calls usecase execute for specific index")
    func removeRecordAtCallsUseCase() async {
        let mockRepo = FlossLogRepositoryMock()
        let record1 = FlossLog(flossDate: Date().addingTimeInterval(-3600))
        let record2 = FlossLog(flossDate: Date().addingTimeInterval(-7200))
        
        // Setup initial state
        mockRepo.fetchedLogs = [record1, record2]
        
        let removeUseCaseMock = RemoveLogRecordUseCaseMock()
        let sut = LogRecordsViewModel(
            recordsRepository: mockRepo,
            removeLogRecordUseCase: removeUseCaseMock
        )
        sut.records = [record1, record2]
        
        // Remove the first record (which is record1 since it's most recent)
        let indexSet = IndexSet(integer: 0)
        await sut.removeRecordAt(indexSet: indexSet)
        
        #expect(removeUseCaseMock.didCallExecuteRecord == true)
        #expect(removeUseCaseMock.passedRecord?.id == record1.id)
    }
}
