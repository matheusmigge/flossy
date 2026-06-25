//
//  LogRecordsViewModel.swift
//  DidIFloss
//
//  Created by Lucas Migge on 01/02/24.
//

import Foundation
import FlossyRecords
import SwiftUI

class LogRecordsViewModel: ObservableObject {
    
    @Published var selectedDate: Date?
    
    var recordsRepository: any FlossLogRepository
    var logRecordsHandler: HandleLogInteractionUseCaseProtocol
    
    @Published var records: [FlossLog] = []
    
    init(recordsRepository: any FlossLogRepository = FlossLogRepositoryFactory.make(),
         logRecordsHandler: HandleLogInteractionUseCaseProtocol = HandleLogInteractionUseCase()
    ) {
        self.recordsRepository = recordsRepository
        self.logRecordsHandler = logRecordsHandler
    }
    
    private func loadRecords() {
        Task {
            guard let records = try? await recordsRepository.fetchLogs() else { return }
            await MainActor.run {
                self.records = records
            }
        }
    }
    
    func viewDidApper() {
        self.loadRecords()
    }
    
    func removeRecordAt(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        
        removeRecord(sectionRecords[index])
    }
    
    func removeRecord(_ record: FlossLog) {
        
        logRecordsHandler.removeLogRecord(for: record)
        loadRecords()
    }
    
    
    var sectionRecords: [FlossLog] {
        let descendingSortedRecords = records.sorted(by: {$0.date > $1.date})
        
        if let date = selectedDate {
            return descendingSortedRecords.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
        } else {
            return descendingSortedRecords
        }
    }
}

