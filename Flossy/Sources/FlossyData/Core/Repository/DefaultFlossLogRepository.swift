//
//  DefaultFlossRecordsRepository.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 25/06/26.
//

import Foundation
import Combine

actor DefaultFlossLogRepository {
    static let shared = DefaultFlossLogRepository(dataSource: SwiftDataFlossRecordDataSource.shared)
    
    private let dataSource: any FlossLogDataSource
    
    var cachedLogs: [FlossLog]?
    
    private final class SubjectWrapper: @unchecked Sendable {
        let subject = PassthroughSubject<[FlossLog], Never>()
    }
    
    private let wrapper = SubjectWrapper()
    
    nonisolated var logsPublisher: AnyPublisher<[FlossLog], Never> {
        wrapper.subject.eraseToAnyPublisher()
    }
    
    init(
        dataSource: any FlossLogDataSource
    ) {
        self.dataSource = dataSource
    }
    
    private func notifyObservers() {
        let currentLogs = cachedLogs ?? []
        wrapper.subject.send(currentLogs)
    }
}

extension DefaultFlossLogRepository: FlossLogRepository {
    
    func fetchLogs() async throws -> [FlossLog] {
        if let cachedLogs {
            return cachedLogs
        }
        
        let logs = try await dataSource.fetchLogs()
        let sortedLogs = logs.sorted { $0.date > $1.date }
        cachedLogs = sortedLogs
        return sortedLogs
    }
    
    func fetchLogs(on date: Date) async throws -> [FlossLog] {
        let logs = try await fetchLogs()
        let logsFromDate = logs.filter {
            Calendar.current.isDate($0.date, inSameDayAs: date)
        }
        return logsFromDate
    }
    
    func addLog(_ flossLog: FlossLog) async throws {
        try await dataSource.insertLog(flossLog)
        if cachedLogs == nil {
            _ = try? await fetchLogs() // populate cache if nil
        } else {
            cachedLogs?.append(flossLog)
            cachedLogs = cachedLogs?.sorted{ $0.date > $1.date }
        }
        notifyObservers()
    }
    
    func deleteLog(id: String) async throws {
        try await dataSource.deleteLog(id: id)
        if cachedLogs == nil {
            _ = try? await fetchLogs()
        } else {
            cachedLogs?.removeAll { $0.id == id }
        }
        notifyObservers()
    }
    
    func deleteLogs(on date: Date) async throws {
        let logs = try await fetchLogs(on: date)
        let logsFromDate = logs.filter {
            Calendar.current.isDate($0.date, inSameDayAs: date)
        }
        for log in logsFromDate {
            try await deleteLog(id: log.id)
        }
        notifyObservers()
    }
    
    func deleteAllLogs() async throws {
        try await dataSource.deleteAllLogs()
        cachedLogs = nil
        notifyObservers()
    }
}
