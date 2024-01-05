//
//  PersistenceManager+KEYS.swift
//  DidIFloss
//
//  Created by Lucas Migge on 04/01/24.
//

import Foundation

extension PersistanceManager {
    /// Holds the key for acessing persisted data in userDefaults
    struct UserDefaultsKeys {
        /// Key of the data of last floss
        static let date: String = "LAST_FLOSS_DATE"
        
        /// Key of floss global count
        static let count: String = "FLOSS_COUNT"
    }
}
