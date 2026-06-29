//
//  PersistenceManager.swift
//  DidIFloss
//
//  Created by Matheus Migge on 27/12/23.
//

import Foundation
import FlossyRecords


class AppPreferences: AppPreferencesProtocol {
    
    public static let shared: AppPreferences = AppPreferences(
        userDefaults: UserDefaults.standard
    )
    
    /// The `UserDefaults` interface used to store and retrieve user settings and preferences.
    let userDefaults: UserDefaultable

    
    init(userDefaults: UserDefaultable) {
        self.userDefaults = userDefaults
    }
    
    /// Checks if the user is new to the app.
    ///
    /// - Returns: `true` if the user is new, `false` otherwise. If the user is new,
    ///   this method will also update the user state in `UserDefaults`.
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
