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
    var flossDataProvider: FlossRecordDataProvider!
    
    var persistenceMananager: PersistenceManager!
    
    override func setUpWithError() throws {
        userDefaults = UserDefaultsMock()
        flossDataProvider = FlossRecordDataProviderMock()
        
        persistenceMananager = PersistenceManager(userDefaults: userDefaults,
                                                  flossRecordService: flossDataProvider)
    }
    
    



}
