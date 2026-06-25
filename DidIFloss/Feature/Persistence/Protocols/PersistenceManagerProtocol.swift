//
//  PersistenceManagerProtocol.swift
//  DidIFloss
//
//  Created by Lucas Migge on 04/01/24.
//

import Foundation

/// A protocol defining methods for a persistence manager responsible for providing data to view models.
///
/// Use this protocol to create a persistence manager that handles the storage, retrieval, and deletion of floss-related data.
/// Conform to this protocol in a class or structure to define the implementation using any desired persistence strategy,
/// such as UserDefaults, Core Data, or a custom storage solution.
///
/// ## Usage
/// Implement this protocol to create a persistence manager tailored to your application's data storage needs.
/// The methods provided cover operations like saving the last floss date, retrieving the last floss date,
/// fetching floss records, deleting specific floss records, and erasing all stored data.
///
/// ## Example
/// ```swift
/// class MyPersistenceManager: PersistenceManagerProtocol {
///     // Implement the methods required by the PersistenceManagerProtocol
/// }
/// ```

protocol PersistenceManagerProtocol: AnyObject {
    func checkIfIsNewUser() -> Bool

}
