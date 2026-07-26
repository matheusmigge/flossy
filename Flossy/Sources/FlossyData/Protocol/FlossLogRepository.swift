//
//  FlossRecordsRepository.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 25/06/26.
//

import Foundation

public protocol FlossLogRepository: Sendable {
    
    func setDelegate(_ delegate: (any FlossRecordsRepositoryDelegate)) async
    
    func fetchLogs() async throws -> [FlossLog]
    func fetchLogs(on date: Date) async throws -> [FlossLog]
    func addLog(_ flossLog: FlossLog) async throws
    func deleteLog(id: String) async throws
    func deleteLogs(on date: Date) async throws
    func deleteAllLogs() async throws
}

public protocol FlossRecordsRepositoryDelegate: AnyObject, Sendable {
    func didUpdateLogs()
}
