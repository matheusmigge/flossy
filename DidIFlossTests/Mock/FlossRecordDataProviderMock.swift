//
//  FlossRecordDataProviderMock.swift
//  DidIFlossTests
//
//  Created by Lucas Migge on 05/02/24.
//

import Foundation
import DidIFloss

struct FlossRecordDataProviderMock: FlossRecordDataProvider {
    func appendRecord(_ date: Date) {
        
    }
    
    func fetchRecords(result: @escaping (Result<[DidIFloss.FlossRecord], Error>) -> Void) {
        
    }
    
    func removeRecord(_ record: DidIFloss.FlossRecord) {
        
    }
    
    func eraseRecords() {
        
    }
    
    
}
