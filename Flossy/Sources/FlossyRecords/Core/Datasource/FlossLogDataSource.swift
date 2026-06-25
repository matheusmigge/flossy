//
//  FlossRecordsDataSource.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 25/06/26.
//


protocol FlossLogDataSource {
    func fetchLogs() async throws -> [FlossLog]
    func insertLog(_ flossLog: FlossLog) async throws
    func deleteLog(id: String) async throws
    func deleteAllLogs() async throws
}
