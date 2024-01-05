//
//  FlossRecordDataProvider.swift
//  DidIFloss
//
//  Created by Lucas Migge on 04/01/24.
//

import Foundation


protocol FlossRecordDataProvider {
    @MainActor func appendRecord(_ record: FlossRecord)
    @MainActor func fetchRecords() async throws -> [FlossRecord]
    @MainActor func removeRecord(_ record: FlossRecord)
    @MainActor func eraseRecords() async
}
