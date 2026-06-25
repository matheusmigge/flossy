//
//  PersistenceManager.swift
//  DidIFloss
//
//  Created by Matheus Migge on 27/12/23.
//

import Foundation
import FlossyRecords

/// A class responsible for managing data persistence and user flossing records.
///
/// `PersistenceManager` handles saving, retrieving, and deleting flossing records,
/// as well as updating user preferences using `UserDefaults`. It interacts with
/// a data provider service to fetch or modify the floss records.
class PersistenceManager: PersistenceManagerProtocol {
    
    /// A shared instance of `PersistenceManager` to maintain a single point of persistence management.
    ///
    /// Use the shared instance to ensure consistency across the app.
    public static let shared: PersistenceManager = PersistenceManager(
        userDefaults: UserDefaults.standard
    )
    
    /// The `UserDefaults` interface used to store and retrieve user settings and preferences.
    let userDefaults: UserDefaultable

    
    /// Initializes a new instance of `PersistenceManager`.
    ///
    /// - Parameters:
    ///   - userDefaults: An object conforming to `UserDefaultable` for storing user preferences.
    ///   - flossRecordService: A service that conforms to `FlossRecordDataProviderProtocol` for fetching and managing floss records.
    ///
    /// **Note:** It's important to use the shared instance to ensure a single instance of the
    /// persistence container for data consistency.
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
