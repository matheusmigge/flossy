//
//  LogRecordsViewModel.swift
//  DidIFloss
//
//  Created by Lucas Migge on 01/02/24.
//

import Foundation
import SwiftUI

class LogRecordsViewModel: ObservableObject {
    
    @Published var selectedDate: Date?
    
    weak var persistence: PersistenceManagerProtocol?
    
    @Published var records: [FlossRecord] = []
    
    init(persistenceService: PersistenceManagerProtocol = PersistenceManager.shared) {
        self.persistence = persistenceService
        
    }
    
    private func loadRecords() {
        guard let safePersistence = persistence else { return }
        
        safePersistence.getFlossRecords { [weak self] result in
            self?.records = result
        }
    }
    
    func viewDidApper() {
        self.loadRecords()
    }
    
    func removeRecordAt(indexSet: IndexSet) {
        guard let safePersistence = persistence else { return }
        
        guard let index = indexSet.first else { return }
        safePersistence.deleteFlossRecord(sectionRecords[index])
        loadRecords()
    }
    
    func removeRecord(_ record: FlossRecord) {
        guard let safePersistence = persistence else { return }
        
        records.removeAll { $0 == record }
        safePersistence.deleteFlossRecord(record)
        loadRecords()
    }
    
    var sectionRecords: [FlossRecord] {
        if let date = selectedDate {
            return records.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
        } else {
            return records
        }
    }
}

