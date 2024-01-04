//
//  FlossRecordDataSouce.swift
//  DidIFloss
//
//  Created by Lucas Migge on 04/01/24.
//

import Foundation
import SwiftData

final class FlossRecordDataSouce {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    static let shared = FlossRecordDataSouce()
    
    @MainActor
    private init() {
        self.modelContainer = try! ModelContainer(for: FlossRecord.self)
        self.modelContext = modelContainer.mainContext
    }
    
    func appendItem(item: FlossRecord) {
        modelContext.insert(item)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchItems() -> [FlossRecord] {
        do {
            return try modelContext.fetch(FetchDescriptor<FlossRecord>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func removeItem(_ item: FlossRecord) {
        modelContext.delete(item)
    }
    
}
