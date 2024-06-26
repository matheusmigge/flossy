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

protocol PersistenceManagerProtocol: AnyObject, FlossRecordsRepositoryProtocol {
    /// Saves the provided date as the last floss date.
    ///
    /// - Parameter date: The date to be saved as the last floss date.
    func saveFlossDate(date: Date)
    
    /// Retrieves the last saved floss date.
    ///
    /// - Returns: The last saved floss date, or `nil` if no date has been saved.
    func getLastFlossDate() -> Date?
    
    /// Deletes the specified floss record.
    ///
    /// - Parameter record: The FlossRecord to be deleted.
    func deleteFlossRecord(_ record: FlossRecord)
    
    /// Deletes a collection of floss records.
    ///
    /// - Parameter records: The FlossRecords array to be deleted.
    func deleteFlossRecords(_ records: [FlossRecord])
    
    /// Erases all stored floss-related data.
    ///
    /// Use this method to clear all persisted floss-related information.
    func eraseData()
    
    
    func checkIfIsNewUser() -> Bool
    
}
