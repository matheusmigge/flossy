//
//  FlossRecordDataProvider.swift
//  DidIFloss
//
//  Created by Lucas Migge on 04/01/24.
//

import Foundation


protocol FlossRecordDataProvider {
    func appendRecord(_ date: Date)
    func fetchRecords(result: @escaping (Result<[FlossRecord], Error>) -> Void)
    func removeRecord(_ record: FlossRecord)
    func eraseRecords()
}
