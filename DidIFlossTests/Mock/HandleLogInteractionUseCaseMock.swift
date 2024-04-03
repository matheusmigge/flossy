//
//  HandleLogInteractionUseCaseMock.swift
//  DidIFlossTests
//
//  Created by Lucas Migge on 26/03/24.
//

import Foundation
@testable import DidIFloss

class HandleLogInteractionUseCaseMock: HandleLogInteractionUseCaseProtocol {
    
    var didCallHandleLogRecord: Bool = false
    var didCallRemoveLogRecord: Bool = false
    var didCallRemoveAllLogRecords: Bool = false
    
    func handleLogRecord(for date: Date) {
        didCallHandleLogRecord = true
    }
    
    func removeLogRecord(for record: FlossRecord) {
        didCallRemoveLogRecord = true
    }
    
    func removeAllLogRecords(for date: Date) {
        didCallRemoveAllLogRecords = true
    }
    
    
}
