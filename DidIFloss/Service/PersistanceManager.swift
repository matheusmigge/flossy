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
    
    
    func getFlossRecords() async -> [FlossRecord] {
        return await flossRecordService.fetchRecords()
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

    func getLastFlossDate() -> Date? {
        return userDefaults.value(forKey: UserDefaultsKeys.date) as? Date
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
    
}






