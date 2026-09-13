import Foundation
import FlossyCore
import FlossyData
@testable import DidIFloss

final class RemoveLogRecordUseCaseMock: RemoveLogRecordUseCaseProtocol, @unchecked Sendable {
    
    var didCallExecuteRecord = false
    var passedRecord: FlossLog?
    
    var didCallExecuteRemoveAll = false
    var passedDate: Date?
    
    func execute(record: FlossLog) async throws {
        didCallExecuteRecord = true
        passedRecord = record
    }
    
    func execute(removeAllFor date: Date) async throws {
        didCallExecuteRemoveAll = true
        passedDate = date
    }
}
