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
        
        DispatchQueue.main.async {
            self.context.insert(record)
            do {
                try self.context.save()
            } catch {
                print("Failed to save context: \(error.localizedDescription)")
            }
        }
    }
    
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
    
    func removeRecord(_ record: FlossRecord) {
        DispatchQueue.main.async { [weak self] in
            self?.context.delete(record)
        }
    }
    
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



