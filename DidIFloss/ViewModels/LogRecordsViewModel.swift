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
    
    let persistence: PersistenceManagerProtocol
    
    @Published var records: [FlossRecord] = []
    
    init(persistenceService: PersistenceManagerProtocol = PersistenceManager.shared) {
        self.persistence = persistenceService
        
    }
    
    func loadRecords() {

        self.persistence.getFlossRecords { [weak self] result in
            self?.records = result
        }
    }
    
    func viewDidApper() {
        self.loadRecords()
        print("View did Appear - LogRecords")
    }
}


extension LogRecordsViewModel: CalendarViewDelegate {
    func didSelectDate(_ date: Date) {
        withAnimation {
            selectedDate = selectedDate == date ? nil : date
        }
    }
    
    func removeRecordAt(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        persistence.deleteFlossRecord(sectionRecords[index])
        loadRecords()
    }
    
    func removeRecord(_ record: FlossRecord) {
        records.removeAll { $0 == record }
        persistence.deleteFlossRecord(record)
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
