//
//  DefaultFlossRecordsRepository.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 25/06/26.
//

import Foundation

struct DefaultFlossLogRepository {
    private let dataSource: any FlossLogDataSource
    
    var delegate: (any FlossRecordsRepositoryDelegate)?
    
    init(dataSource: any FlossLogDataSource) {
        self.dataSource = dataSource
    }
}

extension DefaultFlossLogRepository: FlossLogRepository {
    func fetchLogs() async throws -> [FlossLog] {
        let logs = try await dataSource.fetchLogs()
        return logs.sorted { $0.date > $1.date }
    }
    
    func fetchLogs(on date: Date) async throws -> [FlossLog] {
        let logs = try await dataSource.fetchLogs()
        let logsFromDate = logs.filter {
            Calendar.current.isDate($0.date, inSameDayAs: date)
        }
        return logsFromDate
    }
    
    func addLog(_ flossLog: FlossLog) async throws {
        try await dataSource.insertLog(flossLog)
        delegate?.didUpdateLogs()
    }
    
    func deleteLog(id: String) async throws {
        try await dataSource.deleteLog(id: id)
        delegate?.didUpdateLogs()
    }
    
    func deleteLogs(on date: Date) async throws {
        let logs = try await fetchLogs(on: date)
        let logsFromDate = logs.filter {
            Calendar.current.isDate($0.date, inSameDayAs: date)
        }
        for log in logsFromDate {
            try await deleteLog(id: log.id)
        }
        delegate?.didUpdateLogs()
    }
    
    func deleteAllLogs() async throws {
        try await dataSource.deleteAllLogs()
        delegate?.didUpdateLogs()
    }
}
