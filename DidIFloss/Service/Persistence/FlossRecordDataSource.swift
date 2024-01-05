//
//  FlossRecordDataSouce.swift
//  DidIFloss
//
//  Created by Lucas Migge on 04/01/24.
//

import Foundation
import SwiftData


protocol FlossRecordDataProvider {
    @MainActor func appendRecord(_ record: FlossRecord)
    @MainActor func fetchRecords() async throws -> [FlossRecord]
    @MainActor func removeRecord(_ record: FlossRecord)
    @MainActor func eraseRecords() async
}


@MainActor
final class FlossRecordDataSource: FlossRecordDataProvider {
    
    private let modelContainer: ModelContainer
    
    @MainActor
    private var context: ModelContext {
        modelContainer.mainContext
    }
    
    static let shared = FlossRecordDataSource()
    
    private init() {
        do {
            self.modelContainer = try ModelContainer(for: FlossRecord.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error.localizedDescription)")
        }
    }
    
    func appendRecord(_ record: FlossRecord) {
        Task {
            context.insert(record)
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error.localizedDescription)")
            }
        }
    }

    func fetchRecords() async throws -> [FlossRecord] {
        do {
            return try context.fetch(FetchDescriptor<FlossRecord>())
        } catch {
            print("Failed to fetch records: \(error.localizedDescription)")
            throw error
        }
    }

    func removeRecord(_ record: FlossRecord) {
        context.delete(record)
    }

    func eraseRecords() async {
        do {
            let records = try await fetchRecords()
            for record in records {
                removeRecord(record)
            }
        } catch {
            print("Error while erasing records: \(error.localizedDescription)")
        }
    }
}
    


