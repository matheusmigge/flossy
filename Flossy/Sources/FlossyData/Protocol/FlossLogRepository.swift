//
//  FlossRecordsRepository.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 25/06/26.
//

import Foundation

import Combine

public protocol FlossLogRepository: Sendable {
    var logsPublisher: AnyPublisher<[FlossLog], Never> { get }
    
    func fetchLogs() async throws -> [FlossLog]
    func fetchLogs(on date: Date) async throws -> [FlossLog]
    func addLog(_ log: FlossLog) async throws
    func deleteLog(id: String) async throws
    func deleteLogs(on date: Date) async throws
    func deleteAllLogs() async throws
}
