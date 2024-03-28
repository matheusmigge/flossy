//
//  PersistenceManager.swift
//  DidIFloss
//
//  Created by Matheus Migge on 27/12/23.
//

import Foundation
import Notification

class PersistenceManager: PersistenceManagerProtocol {
    
    let userDefaults: UserDefaultable
    let flossRecordService: FlossRecordDataProviderProtocol
    
    weak var delegate: PersistenceDelegate?
    
    public static let shared: PersistenceManager = PersistenceManager(userDefaults: UserDefaults.standard,
                                                                      flossRecordService: FlossRecordDataSource())
    
    // beware! Should only be one FlossRecordDataSource to maintain persistence container single instance
    // prefer use of shared instante to use a persistenceManager
    init(userDefaults: UserDefaultable, flossRecordService: FlossRecordDataProviderProtocol) {
        self.userDefaults = userDefaults
        self.flossRecordService = flossRecordService
    }
    
    
    func getLastFlossDate() -> Date? {
        return userDefaults.value(forKey: UserDefaultsKeys.date) as? Date
    }
    
    private func updateLastFlossDate(_ date: Date?) {
        self.userDefaults.set(date, forKey: UserDefaultsKeys.date)
        
    }
    
    func getFlossRecords(handler: @escaping ([FlossRecord]) -> Void) {
        
        flossRecordService.fetchRecords { result in
            switch result {
            case .success(let fetchedRecords):
                handler(fetchedRecords)
                
            case .failure(let error):
                print("Failed to fecth Records from Service -> Error: \(error)")
                print("Trying to get last data in userDefaults")
                
                handler([])
            }
        }
    }
    
    func deleteFlossRecord(_ record: FlossRecord) {
        let lasFlossDate = getLastFlossDate()
        flossRecordService.removeRecord(record)
        
        if record.date == lasFlossDate {
            userDefaults.set(nil, forKey: UserDefaultsKeys.date)
            
            flossRecordService.fetchRecords { [weak self] result in
                let data = try? result.get()
                let previousLog = data?.last
                self?.updateLastFlossDate(previousLog?.date)
            }
        }
        
        delegate?.hadChangesInFlossRecordDataBase()
    }
    
    func deleteFlossRecords(_ records: [FlossRecord]) {
        records.forEach { record in
            self.deleteFlossRecord(record)
        }
    }
    
    func saveFlossDate(date: Date) {
        if let lastFlossDate = getLastFlossDate() {
            if date > lastFlossDate {
               updateLastFlossDate(date)
            }
        } else {
            updateLastFlossDate(date)
        }
        
        flossRecordService.appendRecord(date)
    }
    
    func eraseData() {
        userDefaults.set(nil, forKey: UserDefaultsKeys.date)
        userDefaults.set(false, forKey: UserDefaultsKeys.didUserAlreadyUseApp)
        flossRecordService.eraseRecords()
        
    }
    
    func checkIfIsNewUser() -> Bool {
        let isNewUser = !userDefaults.bool(forKey: UserDefaultsKeys.didUserAlreadyUseApp)
        
        if isNewUser {
            userDefaults.set(true, forKey: UserDefaultsKeys.didUserAlreadyUseApp)
            return true
            
        } else {
            return false
        }
    }
    
}

