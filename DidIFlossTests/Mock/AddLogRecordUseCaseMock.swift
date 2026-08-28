import Foundation
@testable import DidIFloss

class AddLogRecordUseCaseMock: AddLogRecordUseCaseProtocol {
    
    var didCallExecute = false
    var passedDate: Date?
    var isDateValidResult = true
    
    func isDateValid(_ date: Date) -> Bool {
        return isDateValidResult
    }
    
    func execute(date: Date) async throws {
        didCallExecute = true
        passedDate = date
        
        if !isDateValid(date) {
            throw AddLogError.dateInFuture
        }
    }
}
