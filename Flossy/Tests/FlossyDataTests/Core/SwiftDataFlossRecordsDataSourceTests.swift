//
//  SwiftDataFlossRecordsDataSourceTests.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 26/06/26.
//

import Testing
import SwiftData
import Foundation
@testable import FlossyRecords

@Suite("SwiftDataFlossRecordDataSource Testing")
struct SwiftDataFlossRecordDataSourceTests {
    
    let sut: SwiftDataFlossRecordDataSource

    init() {
        sut = SwiftDataFlossRecordDataSource(inMemory: true)
    }

    @Test("Should be able to insert a new floss log")
    func insertLog() async throws {
        // Given
        let newLog = FlossLog(id: "123", date: Date(), activity: .floss)
        
        // When
        try await sut.insertLog(newLog)
        let logs = try await sut.fetchLogs()
        
        // Then
        #expect(logs.count == 1)
        #expect(logs.first?.id == "123")
        #expect(logs.first?.activity == .floss)
    }
    
    @Test("Should be able to delete a floss log")
    func deleteLog() async throws {
        // Given
        let log1 = FlossLog(id: "1", date: Date(), activity: .floss)
        let log2 = FlossLog(id: "2", date: Date(), activity: .mouthwash)
        try await sut.insertLog(log1)
        try await sut.insertLog(log2)
        
        // When
        try await sut.deleteLog(id: "1")
        let logs = try await sut.fetchLogs()
        
        // Then
        #expect(logs.count == 1)
        #expect(logs.first?.id == "2", "Log with id 1 should have been deleted.")
    }
    
    @Test("Should be able to delete all floss logs")
    func deleteAllLogs() async throws {
        // Given
        let log1 = FlossLog(id: "1", date: Date(), activity: .floss)
        let log2 = FlossLog(id: "2", date: Date(), activity: .brush)
        try await sut.insertLog(log1)
        try await sut.insertLog(log2)
        
        var logs = try await sut.fetchLogs()
        #expect(logs.count == 2)
    
        try await sut.deleteAllLogs()
        logs = try await sut.fetchLogs()
        
        #expect(logs.isEmpty, "All logs should have been deleted.")
    }
}
