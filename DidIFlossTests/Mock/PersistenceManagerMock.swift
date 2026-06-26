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
    var didCallSaveFlossRecordForDate: Date? = nil
    var isNewUser: Bool = false
    
    func saveFlossDate(date: Date) {
        didCallSaveFlossRecordForDate = date
    }
    
    func getLastFlossDate() -> Date? {
        return nil
    }
    
    func checkIfIsNewUser() -> Bool {
       return isNewUser
    }
}
