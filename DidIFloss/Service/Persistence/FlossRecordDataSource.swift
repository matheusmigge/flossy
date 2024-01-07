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
        print(record.date)
        
        DispatchQueue.main.async {
            self.context.insert(record)
            do {
                try self.context.save()
            } catch {
                print("Failed to save context: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchRecords(result: @escaping ([FlossRecord]) -> Void) {
        DispatchQueue.main.async {
            do {
                let records = try self.context.fetch(FetchDescriptor<FlossRecord>())
                result(records)
            } catch {
                print("Failed to fetch records: \(error.localizedDescription)")
            }
        }
    }
    
    func removeRecord(_ record: FlossRecord) {
        DispatchQueue.main.async { [weak self] in
            self?.context.delete(record)
        }
    }
    
    func eraseRecords() {
        fetchRecords { fetchedRecords in
            fetchedRecords.forEach {
                self.removeRecord($0)
            }
        }
    }
}



