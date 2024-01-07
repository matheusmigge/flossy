//
//  PersistenceManager.swift
//  DidIFloss
//
//  Created by Matheus Migge on 27/12/23.
//

import Foundation

class PersistanceManager: PersistanceManagerProtocol {
    
    let userDefaults: UserDefaultsProtocol
    let flossRecordService: FlossRecordDataProvider
    
    init(userDefaults: UserDefaultsProtocol = UserDefaults.standard,
         flossRecordService: FlossRecordDataProvider = FlossRecordDataSource()
    ) {
        self.userDefaults = userDefaults
        self.flossRecordService = flossRecordService
    }
    
    
    func getLastFlossDate() -> Date? {
        return userDefaults.value(forKey: UserDefaultsKeys.date) as? Date
    }
    
    func getFlossRecords(handler: @escaping ([FlossRecord]) -> Void) {
        var records: [FlossRecord] = []
        
        flossRecordService.fetchRecords { result in
            records = result
            handler(records)
        }
    }
    
    func deleteFlossRecord(_ record: FlossRecord) {
        flossRecordService.removeRecord(record)
    }
    
    func saveLastFlossDate(date: Date) {
        userDefaults.set(date, forKey: UserDefaultsKeys.date)
        
        flossRecordService.appendRecord(date)
    }
    
    func eraseData() {
        userDefaults.set(nil, forKey: UserDefaultsKeys.date)
        flossRecordService.eraseRecords()

    }
}

