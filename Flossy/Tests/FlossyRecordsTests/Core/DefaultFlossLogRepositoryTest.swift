//
//  DefaultFlossLogRepositoryTest.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 27/06/26.
//

import Testing
import Foundation
@testable import FlossyRecords

@Suite("DefaultFlossLogRepository Testing")
struct DefaultFlossLogRepositoryTests {
    
    // MARK: - Mocks & Spies
    
    final class MockFlossLogDataSource: FlossLogDataSource, @unchecked Sendable {
        var mockedLogsToReturn: [FlossLog] = []
        var insertedLogs: [FlossLog] = []
        var deletedLogIDs: [String] = []
        var didCallDeleteAllLogs = false
        var fetchLogsCallCount: Int = 0
        
        func fetchLogs() async throws -> [FlossLog] {
            fetchLogsCallCount += 1
            return mockedLogsToReturn
        }
        
        func insertLog(_ flossLog: FlossLog) async throws {
            insertedLogs.append(flossLog)
        }
        
        func deleteLog(id: String) async throws {
            deletedLogIDs.append(id)
        }
        
        func deleteAllLogs() async throws {
            didCallDeleteAllLogs = true
        }
    }
    
    final class SpyFlossRecordsRepositoryDelegate: FlossRecordsRepositoryDelegate, @unchecked Sendable {
        var didUpdateLogsCallCount = 0
        
        func didUpdateLogs() {
            didUpdateLogsCallCount += 1
        }
    }
    
    struct SUT {
        let dataSourceMock: MockFlossLogDataSource
        let delegateSpy: SpyFlossRecordsRepositoryDelegate
        let repository: DefaultFlossLogRepository
    }
    
    // MARK: - SUT
    let sut: SUT
    
    init() {
        let dataSourceMock = MockFlossLogDataSource()
        let delegateSpy = SpyFlossRecordsRepositoryDelegate()
        let repository = DefaultFlossLogRepository(
            dataSource: dataSourceMock,
            delegate: delegateSpy
        )
        
        self.sut = SUT(dataSourceMock: dataSourceMock, delegateSpy: delegateSpy, repository: repository)
    }
    
    // MARK: - Cache Tests
    
    @Test("Should fetch from Data Source only once and use cache for subsequent calls")
    func fetchLogsUsesCache() async throws {
        let mockDataSource = sut.dataSourceMock
        let repository = sut.repository
        
        mockDataSource.mockedLogsToReturn = [FlossLog(id: "1", date: Date(), activity: .floss)]
        
        // When
        let firstFetch = try await repository.fetchLogs()
        let secondFetch = try await repository.fetchLogs()
        
        // Then
        #expect(firstFetch.count == 1)
        #expect(secondFetch.count == 1)
        #expect(mockDataSource.fetchLogsCallCount == 1, "The repository should use memory cache instead of hitting the DB again")
    }
    
    @Test("Should update cache intelligently when adding a new log")
    func addLogUpdatesCache() async throws {
        let mockDataSource = sut.dataSourceMock
        let repository = sut.repository
        
        // Given
        mockDataSource.mockedLogsToReturn = [FlossLog(id: "1", date: Date(), activity: .floss)]
        let newLog = FlossLog(id: "99", date: Date(), activity: .brush)
        
        // When
        _ = try await repository.fetchLogs()
        try await repository.addLog(newLog)
        let updatedLogs = try await repository.fetchLogs()
        
        // Then
        #expect(updatedLogs.count == 2)
        #expect(updatedLogs.contains { $0.id == "99" })
        #expect(mockDataSource.fetchLogsCallCount == 1, "It should not fetch from DB again to know about the new log")
    }
    
    @Test("Should remove deleted log from memory cache without fetching from DB again")
    func deleteLogUpdatesCache() async throws {
        let mockDataSource = sut.dataSourceMock
        let repository = sut.repository
        
        // Given
        mockDataSource.mockedLogsToReturn = [
            FlossLog(id: "1", date: Date(), activity: .floss),
            FlossLog(id: "2", date: Date(), activity: .mouthwash)
        ]
        
        // When
        _ = try await repository.fetchLogs()
        try await repository.deleteLog(id: "1")
        let updatedLogs = try await repository.fetchLogs()
        
        // Then
        #expect(updatedLogs.count == 1)
        #expect(updatedLogs.first?.id == "2")
        #expect(mockDataSource.fetchLogsCallCount == 1, "It should remove the item from cache without hitting the DB")
    }
    
    @Test("Should clear cache when Delete All Logs has no erros")
    func deleteAllLogsClearsCache() async throws {
        let mockDataSource = sut.dataSourceMock
        let repository = sut.repository
        
        // Given
        mockDataSource.mockedLogsToReturn = [
            FlossLog(id: "1", date: Date(), activity: .floss),
            FlossLog(id: "2", date: Date(), activity: .mouthwash)
            ]
        let _ = try await repository.fetchLogs()
        
        // When
        try await repository.deleteAllLogs()
        
        // Then
        #expect(await repository.cachedLogs == nil)
    }
    
    
    // MARK: - Standard Operation Tests
    
    @Test("Should fetch logs and sort them in descending order (newest first)")
    func fetchLogsSorting() async throws {
        let mockDataSource = sut.dataSourceMock
        let repository = sut.repository
        
        // Given
        let oldestDate = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
        let newestDate = Date()
        let midDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        
        mockDataSource.mockedLogsToReturn = [
            FlossLog(id: "1", date: oldestDate, activity: .floss),
            FlossLog(id: "2", date: newestDate, activity: .brush),
            FlossLog(id: "3", date: midDate, activity: .mouthwash)
        ]
        
        // When
        let fetchedLogs = try await repository.fetchLogs()
        
        // Then
        #expect(fetchedLogs.count == 3)
        #expect(fetchedLogs[0].id == "2", "First log should be the newest")
        #expect(fetchedLogs[1].id == "3", "Second log should be the middle one")
        #expect(fetchedLogs[2].id == "1", "Third log should be the oldest")
    }
    
    @Test("Should fetch logs and filter them by specific date")
    func fetchLogsOnDate() async throws {
        let mockDataSource = sut.dataSourceMock
        let repository = sut.repository
        
        // Given
        let targetDate = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: targetDate)!
        
        mockDataSource.mockedLogsToReturn = [
            FlossLog(id: "1", date: targetDate, activity: .floss), // Match
            FlossLog(id: "2", date: yesterday, activity: .brush),  // No Match
            FlossLog(id: "3", date: targetDate, activity: .floss)  // Match
        ]
        
        // When
        let fetchedLogs = try await repository.fetchLogs(on: targetDate)
        
        // Then
        #expect(fetchedLogs.count == 2)
        #expect(fetchedLogs.contains { $0.id == "1" })
        #expect(fetchedLogs.contains { $0.id == "3" })
    }
    
    @Test("Should insert log into data source and trigger delegate")
    func addLog() async throws {
        let mockDataSource = sut.dataSourceMock
        let delegateSpy = sut.delegateSpy
        let repository = sut.repository
        
        // Given
        let log = FlossLog(id: "99", date: Date(), activity: .floss)
        
        // When
        try await repository.addLog(log)
        
        // Then
        #expect(mockDataSource.insertedLogs.count == 1)
        #expect(mockDataSource.insertedLogs.first?.id == "99")
        #expect(await delegateSpy.didUpdateLogsCallCount == 1, "Delegate should be notified exactly once")
    }
    
    @Test("Should delete specific log from data source and trigger delegate")
    func deleteLog() async throws {
        let mockDataSource = sut.dataSourceMock
        let delegateSpy = sut.delegateSpy
        let repository = sut.repository
        // When
        try await repository.deleteLog(id: "ABC")
        
        // Then
        #expect(mockDataSource.deletedLogIDs.count == 1)
        #expect(mockDataSource.deletedLogIDs.first == "ABC")
        #expect(await delegateSpy.didUpdateLogsCallCount == 1)
    }
    
    @Test("Should delete multiple logs on a specific date and trigger delegate")
    func deleteLogsOnDate() async throws {
        let mockDataSource = sut.dataSourceMock
        let delegateSpy = sut.delegateSpy
        let repository = sut.repository
        
        // Given
        let targetDate = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: targetDate)!
        
        mockDataSource.mockedLogsToReturn = [
            FlossLog(id: "1", date: targetDate, activity: .floss), // Needs deletion
            FlossLog(id: "2", date: yesterday, activity: .brush),  // Should be kept
            FlossLog(id: "3", date: targetDate, activity: .floss)  // Needs deletion
        ]
        
        // When
        try await repository.deleteLogs(on: targetDate)
        
        // Then
        #expect(mockDataSource.deletedLogIDs.count == 2, "Should have deleted exactly 2 logs")
        #expect(mockDataSource.deletedLogIDs.contains("1"))
        #expect(mockDataSource.deletedLogIDs.contains("3"))
        // Note: The call count might be > 1 depending on your actual deleteLogs implementation (it calls deleteLog in a loop and triggers delegate again at the end)
        #expect(await delegateSpy.didUpdateLogsCallCount > 0, "Delegate should be notified")
    }
    
    @Test("Should delete all logs from data source and trigger delegate")
    func deleteAllLogs() async throws {
        let mockDataSource = sut.dataSourceMock
        let delegateSpy = sut.delegateSpy
        let repository = sut.repository
        
        // When
        try await repository.deleteAllLogs()
        
        // Then
        #expect(mockDataSource.didCallDeleteAllLogs == true)
        #expect(await delegateSpy.didUpdateLogsCallCount == 1)
    }
    
    @Test("Should handle deleteLogs safely when no logs exist on target date")
    func deleteLogsSafeHandling() async throws {
        let mockDataSource = sut.dataSourceMock
        let repository = sut.repository
        
        let targetDate = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: targetDate)!
        
        // Given
        mockDataSource.mockedLogsToReturn = [
            FlossLog(id: "1", date: yesterday, activity: .floss)
        ]
        _ = try await repository.fetchLogs()
        
        // When
        try await repository.deleteLogs(on: targetDate)
        
        // Then
        let updatedLogs = try await repository.fetchLogs()
        
        #expect(updatedLogs.count == 1)
        #expect(mockDataSource.deletedLogIDs.isEmpty, "Should not attempt to delete any log from DB")
    }
    
    @Test("Should set new delegate reference")
    func testSetDelegate() async {
        let repository = sut.repository
        let currentDelegate = await repository.delegate
        let newDelegate = SpyFlossRecordsRepositoryDelegate()
        
        await repository.setDelegate(newDelegate)
        
        #expect(currentDelegate !== newDelegate)
        #expect(await repository.delegate === newDelegate)
    }
}
