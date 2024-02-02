//
//  PersistenceManager.swift
//  DidIFloss
//
//  Created by Matheus Migge on 27/12/23.
//

import Foundation

class PersistanceManager: PersistenceManagerProtocol {
    
    let userDefaults: UserDefaultable
    let flossRecordService: FlossRecordDataProvider
    
    static let shared: PersistanceManager = PersistanceManager()
    
    private init(userDefaults: UserDefaults = UserDefaults.standard,
         flossRecordService: FlossRecordDataProvider = FlossRecordDataSource()
    ) {
        self.userDefaults = userDefaults
        self.flossRecordService = flossRecordService
    }
    
    
    func getLastFlossDate() -> Date? {
        return userDefaults.value(forKey: UserDefaultsKeys.date) as? Date
    }
    
    func getFlossRecords(handler: @escaping ([FlossRecord]) -> Void) {
        
        flossRecordService.fetchRecords { result in
            switch result {
            case .success(let fetchedRecords):
                handler(fetchedRecords)
                
            case .failure(let error):
                print("Failed to fecth Records from Service -> Error: \(error)")
                print("Trying to get last data in userDefaults")
                
                guard let lastDate = self.getLastFlossDate() else { return }
                
                let flossRecord = FlossRecord(date: lastDate)
                handler([flossRecord])
            }
        }
    }
    
    func deleteFlossRecord(_ record: FlossRecord) {
        flossRecordService.removeRecord(record)
    }
    
    func saveLastFlossDate(date: Date) {
        userDefaults.set(date, forKey: UserDefaultsKeys.date)
        
        flossRecordService.appendRecord(date)
        print("entrou no manager")
    }
    
    func eraseData() {
        userDefaults.set(nil, forKey: UserDefaultsKeys.date)
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

