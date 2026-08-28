//
//  HandleLogInteractionUseCaseMock.swift
//  DidIFlossTests
//
//  Created by Lucas Migge on 26/03/24.
//

import Foundation
import FlossyData
@testable import DidIFloss

class HandleLogInteractionUseCaseMock: HandleLogInteractionUseCaseProtocol {
    
    var didCallHandleLogRecord: Bool = false
    var didCallRemoveLogRecord: Bool = false
    var didCallRemoveAllLogRecords: Bool = false
    var passedDate: Date?
    
    func handleLogRecord(for date: Date) {
        didCallHandleLogRecord = true
        passedDate = date
    }
    
    func removeLogRecord(for record: FlossLog) {
        didCallRemoveLogRecord = true
    }
    
    func removeAllLogRecords(for date: Date) {
        didCallRemoveAllLogRecords = true
    }
    
    
}
