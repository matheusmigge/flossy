//
//  FlossRecordDataSouce.swift
//  DidIFloss
//
//  Created by Lucas Migge on 04/01/24.
//

import Foundation
import SwiftData


/// A data source for managing `FlossRecord` entities using `SwiftData`.
 ///
 /// `FlossRecordDataSource` provides methods for appending, fetching, removing,
 /// and erasing floss records. It uses a `ModelContainer` to manage the context
 /// and perform CRUD operations on the data.
final class FlossRecordDataSource: FlossRecordDataProviderProtocol {
    
    // MARK: - Properties
    
    /// The `ModelContainer` used to manage the `FlossRecord` entities.
    private let modelContainer: ModelContainer
    
    /// The `ModelContext` associated with the main actor, used to interact with the model data.
    @MainActor
    private var context: ModelContext {
        modelContainer.mainContext
    }
    
    // MARK: - Initialization
    
    /// Initializes a new instance of `FlossRecordDataSource` and sets up the `ModelContainer`.
    ///
    /// - Throws: A fatal error if the `ModelContainer` fails to initialize.
    init() {
        do {
            self.modelContainer = try ModelContainer(for: FlossRecord.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Methods
    
    /// Appends a new `FlossRecord` with the given date.
    ///
    /// - Parameter date: The date of the flossing event to be added.
    func appendRecord(_ date: Date) {
        let record = FlossRecord(date: date)
        
        DispatchQueue.main.async {
            self.context.insert(record)
            do {
                try self.context.save()
            } catch {
                print("Failed to save context: \(error.localizedDescription)")
            }
        }
    }
    
    /// Fetches all `FlossRecord` entities and returns the result asynchronously.
    ///
    /// - Parameter result: A closure that returns a `Result` containing an array of `FlossRecord`
    ///   objects or an error if the fetch operation fails.
    func fetchRecords(result: @escaping (Result<[FlossRecord], Error>) -> Void) {
        DispatchQueue.main.async {
            do {
                let records = try self.context.fetch(FetchDescriptor<FlossRecord>())
                result(.success(records))
            } catch {
                result(.failure(error))
            }
        }
    }
    
    /// Removes a specified `FlossRecord` from the context.
    ///
    /// - Parameter record: The `FlossRecord` object to be deleted.
    func removeRecord(_ record: FlossRecord) {
        DispatchQueue.main.async { [weak self] in
            self?.context.delete(record)
        }
    }
    
    /// Erases all `FlossRecord` entities from the context.
    ///
    /// This method fetches all records and deletes them one by one. If the fetch
    /// operation fails, an error message is printed.
    func eraseRecords() {
        fetchRecords { [weak self] result in
            switch result {
            case .success(let records):
                records.forEach {
                    self?.removeRecord($0)
                }
            case .failure(let error):
                print("Failed to erase Data -> Error: \(error)")
            }
        }
    }
}
