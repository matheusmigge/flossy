//
//  PersistenceManager.swift
//  DidIFloss
//
//  Created by Matheus Migge on 27/12/23.
//

import Foundation

class PersistanceManager {
    
    let dateKey: String = "LAST_FLOSS_DATE"
    let countKey: String = "FLOSS_COUNT"
    
    // last floss date
    // save
    func saveLastFlossDate(date: Date) {
        UserDefaults.standard.set(date, forKey: dateKey)
    }
    // read
    func getLastFlossDate() -> Date? {
        return UserDefaults.standard.value(forKey: dateKey) as? Date
    }
    
    // floss count
    // save
    func saveFlossCount(_ count: Int) {
        UserDefaults.standard.set(count, forKey: countKey)
    }
    // read
    func getFlossCount() -> Int {
        return UserDefaults.standard.integer(forKey: countKey)
    }
    
}
