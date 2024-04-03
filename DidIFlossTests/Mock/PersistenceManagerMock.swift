//
//  PersistenceManagerMock.swift
//  DidIFlossTests
//
//  Created by Lucas Migge on 26/03/24.
//

import Foundation
@testable import DidIFloss

class PersistenceManagerMock: PersistenceManagerProtocol {
    
    var logs: [FlossRecord] = []
    var didCallGetFlossRecord: Bool = false
    var didCallSaveFlossRecordForDate: Date? = nil
    var didCallRemoveFlossRecordOn: FlossRecord? = nil
    var didCallRemoveAllFlossRecordsOn: [FlossRecord] = []
    var isNewUser: Bool = false
    
    func saveFlossDate(date: Date) {
        didCallSaveFlossRecordForDate = date
    }
    
    func getLastFlossDate() -> Date? {
        return nil
    }
    
    func getFlossRecords(handler: @escaping ([FlossRecord]) -> Void) {
        didCallGetFlossRecord = true
        handler(logs)
        
    }
    
    func deleteFlossRecord(_ record: FlossRecord) {
        didCallRemoveFlossRecordOn = record
        logs = logs.filter({$0.id != record.id})
    }
    
    func deleteFlossRecords(_ records: [FlossRecord]) {
        didCallRemoveAllFlossRecordsOn = records
        
    }
    
    func eraseData() {
        
    }
    
    func checkIfIsNewUser() -> Bool {
       return isNewUser
    }
    
    var delegate: (any DidIFloss.PersistenceDelegate)?
    
    
}
