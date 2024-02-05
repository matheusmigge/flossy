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
    var flossDataProvider: FlossRecordDataProviderMock!
    
    var persistenceManager: PersistenceManager!
    
    override func setUpWithError() throws {
        userDefaults = UserDefaultsMock()
        flossDataProvider = FlossRecordDataProviderMock()
        
        persistenceManager = PersistenceManager(userDefaults: userDefaults,
                                                  flossRecordService: flossDataProvider)
    }

    func testGetLastFlossDateReturnLastFlossPersisted() {
        userDefaults.lastFlossDate = .distantFuture
        
        let lastFlossDate = persistenceManager.getLastFlossDate()
        
        XCTAssertEqual(Date.distantFuture, lastFlossDate)
        
    }
    
    func testGetLastFlossDateReturnNilIfNoneRecordsPersisted() {
        userDefaults.lastFlossDate = nil
        
        let lastFlossDate = persistenceManager.getLastFlossDate()
        
        XCTAssertNil(lastFlossDate)
    }

    
    func testGetFlossRecordsReturnsArrayFromDataProvider() {

        var records = [FlossRecord]()
        flossDataProvider.records = FlossRecord.sampleData
        
        persistenceManager.getFlossRecords { result in
            records = result
            XCTAssertFalse(records.isEmpty)
        }
    }
    
    func testRemoveFlossRecordRemovesFromDataProvider() {
        let log = FlossRecord()
        
        persistenceManager.deleteFlossRecord(log)
        
        XCTAssertEqual(log, flossDataProvider.didCallRemoveFlossRecord)
        
    }
    
    func testRemoveFlossRecordCallsObserver() {
        persistenceManager.observer = flossDataProvider
        let log = FlossRecord()
        
        persistenceManager.deleteFlossRecord(log)
        
        XCTAssertTrue(flossDataProvider.hasBeenNotifiedOfChangesByDelegate)
        
    }
    
    func testRemoveFlossUpdatesLastFlossDateIfRecordWasMostRecent() {
        let longDate: Date = .distantPast
        let recentDate: Date = .now
        let previousLog = FlossRecord(date: longDate)
        let recentLog = FlossRecord(date: recentDate)
        userDefaults.lastFlossDate = recentDate
        flossDataProvider.records = [previousLog, recentLog]
        
        persistenceManager.deleteFlossRecord(recentLog)
        
        XCTAssertEqual(persistenceManager.getLastFlossDate(), longDate)
        
    }

    func testSaveFlossDateCallsPersistedMethodDependency() {
        
    }
    
    func testCheckIfNewUserReturnsTrueIfFirstTimeInApp() {
        
    }
        
    func testCheckIfNewUserReturnFalseIfUserAlreadyUseApp() {
        
    }
    
    func testEraseAllDataRemovesAllUserPersistedData() {
        
    }

}
