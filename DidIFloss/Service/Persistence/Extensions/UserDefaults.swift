//
//  UserDefaults.swift
//  DidIFloss
//
//  Created by Lucas Migge on 09/01/24.
//

import Foundation

/// An extension of UserDefaults adopting the UserDefaultable.
///
/// This extension makes UserDefaults conform to UserDefaultable,
/// allowing you to use UserDefaults or any custom implementation conforming to UserDefaultsProtocol interchangeably.
extension UserDefaults: UserDefaultable {}
