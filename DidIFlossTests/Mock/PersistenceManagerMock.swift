//
//  PersistenceManagerMock.swift
//  DidIFlossTests
//
//  Created by Lucas Migge on 26/03/24.
//

import Foundation
@testable import DidIFloss

class PersistenceManagerMock: PersistenceManagerProtocol {
    func saveFlossDate(date: Date) {
        
    }
    
    func getLastFlossDate() -> Date? {
        return nil
    }
    
    func getFlossRecords(handler: @escaping ([FlossRecord]) -> Void) {
        
    }
    
    func deleteFlossRecord(_ record: FlossRecord) {
        
    }
    
    func deleteFlossRecords(_ records: [FlossRecord]) {
        
    }
    
    func eraseData() {
        
    }
    
    func checkIfIsNewUser() -> Bool {
       return false
    }
    
    var observer: (any PersistenceObserver)?
    
    
}
