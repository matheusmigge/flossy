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
    
    weak var recordsRepository: FlossRecordsRepositoryProtocol?
    weak var userFeedbackService: HapticsManagerProtocol?
    var logRecordsHandler: HandleLogInteractionUseCaseProtocol
    
    @Published var records: [FlossRecord] = []
    
    init(persistenceService: FlossRecordsRepositoryProtocol = PersistenceManager.shared,
         userFeedbackService: HapticsManagerProtocol = HapticsManager.shared,
         logRecordsHandler: HandleLogInteractionUseCaseProtocol = HandleLogInteractionUseCase()
    ) {
        self.recordsRepository = persistenceService
        self.userFeedbackService = userFeedbackService
        self.logRecordsHandler = logRecordsHandler
        
    }
    
    private func loadRecords() {
        guard let safePersistence = recordsRepository else { return }
        
        safePersistence.getFlossRecords { [weak self] result in
            self?.records = result
        }
    }
    
    func viewDidApper() {
        self.loadRecords()
    }
    
    func removeRecordAt(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        
        removeRecord(sectionRecords[index])
    }
    
    func removeRecord(_ record: FlossRecord) {
        
        logRecordsHandler.removeLogRecord(for: record)
        
        loadRecords()
        userFeedbackService?.vibrateLogRemoval()
    }
    
    
    var sectionRecords: [FlossRecord] {
        let descendingSortedRecords = records.sorted(by: {$0.date > $1.date})
        
        if let date = selectedDate {
            return descendingSortedRecords.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
        } else {
            return descendingSortedRecords
        }
    }
}

