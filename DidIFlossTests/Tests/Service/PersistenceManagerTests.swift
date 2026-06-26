//
//  PersistenceManagerTests.swift
//  DidIFlossTests
//
//  Created by Lucas Migge on 05/02/24.
//

import XCTest
@testable import DidIFloss

final class PersistenceManagerTests: XCTestCase {

    var userDefaults: UserDefaultsMock!
    
    var persistenceManager: PersistenceManager!
    
    override func setUpWithError() throws {
        userDefaults = UserDefaultsMock()
        
        persistenceManager = PersistenceManager(userDefaults: userDefaults)
    }
    
    func testCheckIfNewUserReturnsTrueIfFirstTimeInApp() {
        userDefaults.didUserAlreadyUseApp = false
        
        XCTAssertTrue(persistenceManager.checkIfIsNewUser())
    }
        
    func testCheckIfNewUserReturnFalseIfUserAlreadyUseApp() {
        
        userDefaults.didUserAlreadyUseApp = false
        
        // first use
        _ = persistenceManager.checkIfIsNewUser()
        // second use
        let isNewUser = persistenceManager.checkIfIsNewUser()
        
        XCTAssertFalse(isNewUser)
        
    }
}
