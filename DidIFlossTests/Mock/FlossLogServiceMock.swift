import Foundation
import FlossyCore
import FlossyData
@testable import DidIFloss

class FlossLogServiceMock: FlossLogServicing, @unchecked Sendable {
    var didCallAddLog = false
    var didCallRemoveLog = false
    var didCallRemoveLogs = false
    var didCallIsDateValid = false
    var passedDate: Date?
    var passedRecord: FlossLog?
    var isDateValidResult = true
    
    func isDateValid(_ date: Date) -> Bool {
        didCallIsDateValid = true
        return isDateValidResult
    }
    
    func addLogRecord(date: Date) async throws {
        didCallAddLog = true
        passedDate = date
    }
    
    func removeLogRecord(_ record: FlossLog) async throws {
        didCallRemoveLog = true
        passedRecord = record
    }
    
    func removeLogs(removeAllFor date: Date) async throws {
        didCallRemoveLogs = true
        passedDate = date
    }
}
