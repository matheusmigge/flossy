//
//  SwiftDataFlossRecordDataSource.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 25/06/26.
//

import SwiftData

actor SwiftDataFlossRecordDataSource {
        static let shared: SwiftDataFlossRecordDataSource = .init()
        
        private let modelContainer: ModelContainer
        
        init(inMemory: Bool = false) {
            do {
                let configuration = ModelConfiguration(isStoredInMemoryOnly: inMemory)
                self.modelContainer = try ModelContainer(for: FlossRecordEntity.self, configurations: configuration)
            } catch {
                fatalError("Failed to initialize ModelContainer: \(error.localizedDescription)")
            }
        }
}

extension SwiftDataFlossRecordDataSource: FlossLogDataSource {
    func fetchLogs() async throws -> [FlossLog] {
        let localContext = ModelContext(modelContainer)
        let records = try localContext.fetch(FetchDescriptor<FlossRecordEntity>())
        return records.compactMap { FlossLog(from: $0) }
    }
    
    func insertLog(_ flossLog: FlossLog) async throws {
        let localContext = ModelContext(modelContainer)
        let entity = FlossRecordEntity(from: flossLog)
        localContext.insert(entity)
        try localContext.save()
    }
    
    
    func deleteLog(id: String) async throws {
        let localContext = ModelContext(modelContainer)
        let records = try localContext.fetch(FetchDescriptor<FlossRecordEntity>())
        if  let flossLog = records.first(where: { $0.id == id }) {
            localContext.delete(flossLog)
            try localContext.save()
        }
    }
    
    func deleteAllLogs() async throws {
        let localContext = ModelContext(modelContainer)
        let records = try localContext.fetch(FetchDescriptor<FlossRecordEntity>())
        for record in records {
            localContext.delete(record)
        }
        try localContext.save()
    }
    
    
}
