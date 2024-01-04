//
//  FlossRecordDataSouce.swift
//  DidIFloss
//
//  Created by Lucas Migge on 04/01/24.
//

import Foundation
import SwiftData

@MainActor
final class FlossRecordDataSouce: FlossRecordDataProvider {
    
    let modelContainer: ModelContainer?
    
    static let shared = FlossRecordDataSouce()
    
    @MainActor
    var context: ModelContext? {
        modelContainer?.mainContext
    }
    
    @MainActor
    private init() {
        do {
            self.modelContainer = try ModelContainer(for: FlossRecord.self)
        } catch {
            self.modelContainer = nil
            print("ERROR: Failed to load ModelContainer -> \(error.localizedDescription)")
        }
      
    }
    
    @MainActor
    func appendRecord(_ record: FlossRecord) {
        context?.insert(record)
        do {
            try context?.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    func fetchRecords() -> [FlossRecord] {
        do {
            return try context?.fetch(FetchDescriptor<FlossRecord>()) ?? []
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    @MainActor
    func removeRecord(_ record: FlossRecord) {
        context?.delete(record)
    }
    
    @MainActor
    func eraseRecords() {
        Task {
            let records = self.fetchRecords()
            records.forEach { record in
                self.removeRecord(record)
            }

        }
    }
    
}

protocol FlossRecordDataProvider {
    func appendRecord(_ record: FlossRecord) async
    
    func fetchRecords() async -> [FlossRecord]
    
    func removeRecord(_ record: FlossRecord) async
    
    func eraseRecords() async
}
