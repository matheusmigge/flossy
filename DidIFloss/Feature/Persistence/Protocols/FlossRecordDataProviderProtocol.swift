//
//  FlossRecordDataProvider.swift
//  DidIFloss
//
//  Created by Lucas Migge on 04/01/24.
//

import Foundation


/// A protocol for managing dental floss records.
///
/// Use this protocol to define the requirements for providing and managing records of dental floss usage.
/// Conform to this protocol in your data provider to enable the storage, retrieval, and manipulation of floss records.
///
/// ## Usage
/// Implement this protocol in a class or structure to create a data provider for floss records.
/// The data provider should handle operations such as appending new records, fetching existing records,
/// removing specific records, and erasing all records.
///
/// ## Example
/// ```swift
/// class MyFlossRecordProvider: FlossRecordDataProvider {
///     // Implement the methods required by the FlossRecordDataProvider protocol
/// }
/// ```

public protocol FlossRecordDataProviderProtocol {
    /// Appends a new floss record with the given date.
    ///
    /// - Parameter date: The date when the flossing activity occurred.
    func appendRecord(_ date: Date)
    
    /// Fetches the existing floss records.
    ///
    /// - Parameter result: A closure that receives a Result containing an array of FlossRecord or an error.
    func fetchRecords(result: @escaping (Result<[FlossRecord], Error>) -> Void)
    
    /// Removes the specified floss record.
    ///
    /// - Parameter record: The FlossRecord to be removed.
    func removeRecord(_ record: FlossRecord)
    
    /// Erases all floss records.
    ///
    /// Use this method to clear all recorded floss activities.
    func eraseRecords()
}
