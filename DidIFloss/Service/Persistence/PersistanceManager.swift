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
    
    func getFlossRecords() async -> [FlossRecord] {
        do {
            let records = try await flossRecordService.fetchRecords()
            
            return records.sorted(by: {$0.date > $1.date})
        } catch {
            print("Failed to load Data")
            return []
        }
    }
    
    func deleteFlossRecord(_ record: FlossRecord) {
        Task {
            await flossRecordService.removeRecord(record)
        }
    }
    
    func saveLastFlossDate(date: Date) {
        userDefaults.set(date, forKey: UserDefaultsKeys.date)
        
        Task {
            await flossRecordService.appendRecord(date)
        }
    }
    
    func eraseData() {
        userDefaults.set(nil, forKey: UserDefaultsKeys.date)
        flossRecordService.eraseRecords()

    }
}

