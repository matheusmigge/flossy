//
//  LogRecordsViewModel.swift
//  DidIFloss
//
//  Created by Lucas Migge on 01/02/24.
//

import Foundation
import FlossyData
import SwiftUI

import Combine

@Observable
class LogRecordsViewModel: ScreenViewModel {
    
    var selectedDate: Date?
    
    var recordsRepository: any FlossLogRepository
    var logRecordsHandler: HandleLogInteractionUseCaseProtocol
    
    var records: [FlossLog] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init(recordsRepository: any FlossLogRepository = DefaultFlossLogRepositoryFactory.make(),
         logRecordsHandler: HandleLogInteractionUseCaseProtocol = HandleLogInteractionUseCase()
    ) {
        self.recordsRepository = recordsRepository
        self.logRecordsHandler = logRecordsHandler
        
        setupBindings()
    }
    
    private func setupBindings() {
        recordsRepository.logsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] logs in
                self?.records = logs
            }
            .store(in: &cancellables)
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
        // Combine publisher will update records, no need to call loadRecords() here anymore if we want, but calling it is fine
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

