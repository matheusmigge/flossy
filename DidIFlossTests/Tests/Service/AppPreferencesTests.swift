//
//  PersistenceManagerTests.swift
//  DidIFlossTests
//
//  Created by Lucas Migge on 05/02/24.
//

import XCTest
@testable import DidIFloss

final class AppPreferencesTests: XCTestCase {

    var userDefaults: UserDefaultsMock!
    
    var sut: AppPreferences!
    
    override func setUpWithError() throws {
        userDefaults = UserDefaultsMock()
        
        sut = AppPreferences(userDefaults: userDefaults)
    }
    
    func testCheckIfNewUserReturnsTrueIfFirstTimeInApp() {
        userDefaults.didUserAlreadyUseApp = false
        
        XCTAssertTrue(sut.checkIfIsNewUser())
    }
        
    func testCheckIfNewUserReturnFalseIfUserAlreadyUseApp() {
        
        userDefaults.didUserAlreadyUseApp = false
        
        // first use
        _ = sut.checkIfIsNewUser()
        // second use
        let isNewUser = sut.checkIfIsNewUser()
        
        XCTAssertFalse(isNewUser)
        
    }
}
