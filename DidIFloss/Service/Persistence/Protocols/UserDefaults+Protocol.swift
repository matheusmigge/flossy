//
//  UserDefaults+Protocol.swift
//  DidIFloss
//
//  Created by Lucas Migge on 04/01/24.
//

import Foundation

/// A protocol defining a subset of UserDefaults methods for simplified testing and dependency injection.
///
/// Use this protocol to create a mock or a custom implementation for UserDefaults in scenarios
/// where you want to isolate and test code that interacts with UserDefaults.
///
/// ## Usage
/// Conform to this protocol in a class or structure to create a custom UserDefaults implementation or mock.
/// This allows you to replace the standard UserDefaults with your implementation for testing purposes.
///
/// ## Example
/// ```swift
/// class MockUserDefaults: UserDefaultsProtocol {
///     // Implement the methods required by the UserDefaultsProtocol
/// }
/// ```
public protocol UserDefaultsProtocol {
    /// Sets the value of the specified default key.
    ///
    /// - Parameters:
    ///   - value: The value to set for the default key.
    ///   - forKey: The key with which to associate the value.
    func set(_ value: Any?, forKey: String)
    
    /// Returns the integer value associated with the specified default key.
    ///
    /// - Parameter forKey: The key for which to retrieve the associated integer value.
    /// - Returns: The integer value associated with the specified key.
    func integer(forKey: String) -> Int
    
    /// Returns the value associated with the specified default key.
    ///
    /// - Parameter forKey: The key for which to retrieve the associated value.
    /// - Returns: The value associated with the specified key.
    func value(forKey: String) -> Any?
}

/// An extension of UserDefaults adopting the UserDefaultsProtocol.
///
/// This extension makes UserDefaults conform to UserDefaultsProtocol,
/// allowing you to use UserDefaults or any custom implementation conforming to UserDefaultsProtocol interchangeably.
extension UserDefaults: UserDefaultsProtocol {}
