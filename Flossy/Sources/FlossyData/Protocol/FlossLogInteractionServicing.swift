//
//  FlossLogInteractionServicing.swift
//  Flossy
//

import Foundation

public protocol FlossLogInteractionServicing: Sendable {
    func fetchLogs() async throws -> [FlossLog]
    
    @discardableResult
    func addLog(_ log: FlossLog) async throws -> [FlossLog]
    
    @discardableResult
    func removeLog(_ log: FlossLog) async throws -> [FlossLog]
}
