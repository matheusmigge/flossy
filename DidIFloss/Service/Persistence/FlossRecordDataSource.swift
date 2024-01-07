//
//  FlossRecordDataSouce.swift
//  DidIFloss
//
//  Created by Lucas Migge on 04/01/24.
//

import Foundation
import SwiftData


final class FlossRecordDataSource: FlossRecordDataProvider {
    
    private let modelContainer: ModelContainer
    
    @MainActor
    private var context: ModelContext {
        modelContainer.mainContext
    }
    
    
    init() {
        do {
            self.modelContainer = try ModelContainer(for: FlossRecord.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error.localizedDescription)")
        }
    }
    
    func appendRecord(_ date: Date) {
        let record = FlossRecord(date: date)
        
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

    func eraseRecords() {
        Task {
            do {
                let records = try await fetchRecords()
                for record in records {
                    await removeRecord(record)
                }
            } catch {
                print("Error while erasing records: \(error.localizedDescription)")
            }
        }
    }
}
    


