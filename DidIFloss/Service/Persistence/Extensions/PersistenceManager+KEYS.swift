//
//  PersistenceManager+KEYS.swift
//  DidIFloss
//
//  Created by Lucas Migge on 04/01/24.
//

import Foundation

extension PersistenceManager {
    
    /// Holds the key for acessing persisted data in userDefaults
    public struct UserDefaultsKeys {
        
        /// Key of the data of last floss
        static let date: String = "LAST_FLOSS_DATE"
        
        // Key storing if should show a onboarding
        static let didUserAlreadyUseApp: String = "DID_USER_ALREADY_USE_APP"
    }
}
