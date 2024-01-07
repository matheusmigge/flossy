//
//  FlossRecordDataProvider.swift
//  DidIFloss
//
//  Created by Lucas Migge on 04/01/24.
//

import Foundation


protocol FlossRecordDataProvider {
    @MainActor func appendRecord(_ date: Date)
    @MainActor func fetchRecords() async throws -> [FlossRecord]
    @MainActor func removeRecord(_ record: FlossRecord)
    func eraseRecords()
}
