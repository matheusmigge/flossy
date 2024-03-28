//
//  PersistenceManagerMock.swift
//  DidIFlossTests
//
//  Created by Lucas Migge on 26/03/24.
//

import Foundation
@testable import DidIFloss

class PersistenceManagerMock: PersistenceManagerProtocol {
    
    var didCallGetFlossRecord: Bool = false
    var didCallSaveFlossRecord: Bool = false
    var isNewUser: Bool = false
    
    func saveFlossDate(date: Date) {
        didCallSaveFlossRecord = true
    }
    
    func getLastFlossDate() -> Date? {
        return nil
    }
    
    func getFlossRecords(handler: @escaping ([FlossRecord]) -> Void) {
        didCallGetFlossRecord = true
        
    }
    
    func deleteFlossRecord(_ record: FlossRecord) {
        
    }
    
    func deleteFlossRecords(_ records: [FlossRecord]) {
        
    }
    
    func eraseData() {
        
    }
    
    func checkIfIsNewUser() -> Bool {
       return isNewUser
    }
    
    var delegate: (any DidIFloss.PersistenceDelegate)?
    
    
}
