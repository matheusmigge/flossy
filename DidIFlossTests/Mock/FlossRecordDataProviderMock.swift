//
//  FlossRecordDataProviderMock.swift
//  DidIFlossTests
//
//  Created by Lucas Migge on 05/02/24.
//

import Foundation
import SwiftData
@testable import DidIFloss

final class FlossRecordDataProviderMock: FlossRecordDataProviderProtocol {
    
    
    var shouldFetchRecordsBeSuccessful: Bool = true
    var hasBeenNotifiedOfChangesByDelegate: Bool = false
    var didCallRemoveFlossRecordOn: FlossRecord?
    var didCallAddFlossRecordOn: Date?
    var records: [FlossRecord] = []
    
    private let modelContainer: ModelContainer
    
    @MainActor
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    
    init() {
        do {
            let configuration: ModelConfiguration = ModelConfiguration(isStoredInMemoryOnly: true)
            self.modelContainer = try ModelContainer(for: FlossRecord.self, configurations: configuration)
            
            
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error.localizedDescription)")
        }
    }
    
    func appendRecord(_ date: Date) {
        didCallAddFlossRecordOn = date
        
    }
    
    
    
    func fetchRecords(result: @escaping (Result<[FlossRecord], Error>) -> Void) {
        if shouldFetchRecordsBeSuccessful {
            result(.success(records))
        } else {
            result(.failure(NSError()))
        }
        
    }
    
    func removeRecord(_ record: DidIFloss.FlossRecord) {
        didCallRemoveFlossRecordOn = record
        records = records.filter({$0 != record})
    }
    
    func eraseRecords() {
        records.removeAll()
    }
    
    
}

extension FlossRecordDataProviderMock: PersistenceDelegate {
    func hadChangesInFlossRecordDataBase() {
        hasBeenNotifiedOfChangesByDelegate = true
    }
    
    
}
