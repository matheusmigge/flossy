//
//  PersistenceManager+KEYS.swift
//  DidIFloss
//
//  Created by Lucas Migge on 04/01/24.
//

import Foundation

extension AppPreferences {
    
    /// A struct that holds the keys used for accessing persisted data in `UserDefaults`.
    ///
    /// `UserDefaultsKeys` provides string constants that act as unique identifiers
    /// for persisting and retrieving specific pieces of data related to flossing
    /// records and user onboarding.
    public struct UserDefaultsKeys {
        /// The key for checking if the user has already used the app.
        ///
        /// This key is used to determine whether to show the onboarding screen
        /// when the app is launched for the first time.
        static let didUserAlreadyUseApp: String = "DID_USER_ALREADY_USE_APP"
    }
}
