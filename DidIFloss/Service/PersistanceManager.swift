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
         flossRecordService: FlossRecordDataProvider = FlossRecordDataSouce.shared
    ) {
        self.userDefaults = userDefaults
        self.flossRecordService = flossRecordService
    }
    
    
    func getLastFlossDate() -> Date? {
        return userDefaults.value(forKey: UserDefaultsKeys.date) as? Date
    }
    
    func getFlossRecords() async -> [FlossRecord] {
        let records = await flossRecordService.fetchRecords()
        
        return records.sorted(by: {$0.date > $1.date})
    }
    
    
    func deleteFlossRecord(_ record: FlossRecord) {
        Task {
            await flossRecordService.removeRecord(record)
        }
    }
    
    func saveLastFlossDate(date: Date) {
        userDefaults.set(date, forKey: UserDefaultsKeys.date)
        Task {
            await flossRecordService.appendRecord(FlossRecord(date: .now))
        }
    }

    func appendFlossRecord(_ record: FlossRecord) {
        Task {
            await flossRecordService.appendRecord(record)
        }
    }

    func saveFlossCount(_ count: Int) {
        userDefaults.set(count, forKey: UserDefaultsKeys.count)
    }

    func getFlossCount() -> Int {
        return userDefaults.integer(forKey: UserDefaultsKeys.count)
    }
    
    func eraseData() {
        userDefaults.set(0, forKey: UserDefaultsKeys.count)
        userDefaults.set(nil, forKey: UserDefaultsKeys.date)
        
        Task {
           await flossRecordService.eraseRecords()
        }
    }
    
}

