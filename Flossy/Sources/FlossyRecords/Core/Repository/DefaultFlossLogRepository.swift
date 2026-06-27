//
//  DefaultFlossRecordsRepository.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 25/06/26.
//

import Foundation


actor DefaultFlossLogRepository {
    
    private let dataSource: any FlossLogDataSource
    
    var cachedLogs: [FlossLog]?
    
    weak var delegate: (any FlossRecordsRepositoryDelegate)?
    
    init(
        dataSource: any FlossLogDataSource,
         delegate: (any FlossRecordsRepositoryDelegate)? = nil
    ) {
        self.dataSource = dataSource
        self.delegate = delegate
    }
    
}

extension DefaultFlossLogRepository: FlossLogRepository {
    
    func setDelegate(_ delegate: (any FlossRecordsRepositoryDelegate)) async {
        self.delegate = delegate
    }
    
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
        cachedLogs?.append(flossLog)
        cachedLogs = cachedLogs?.sorted{ $0.date > $1.date }
        delegate?.didUpdateLogs()
    }
    
    func deleteLog(id: String) async throws {
        try await dataSource.deleteLog(id: id)
        cachedLogs?.removeAll { $0.id == id }
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
