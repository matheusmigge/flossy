//
//  LogRecordsViewModel.swift
//  DidIFloss
//
//  Created by Lucas Migge on 01/02/24.
//

import Foundation
import Notification
import SwiftUI

class LogRecordsViewModel: ObservableObject {
    
    @Published var selectedDate: Date?
    
    weak var persistence: PersistenceManagerProtocol?
    var notificationService: FlossRemindersService?
    
    @Published var records: [FlossRecord] = []
    
    init(persistenceService: PersistenceManagerProtocol = PersistenceManager.shared, notificationService: FlossRemindersService = NotificationService.current()) {
        self.persistence = persistenceService
        self.notificationService = notificationService
        
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
        guard let index = indexSet.first else { return }
        
        removeRecord(sectionRecords[index])
    }
    
    func removeRecord(_ record: FlossRecord) {
        guard let safePersistence = persistence else { return }
        
        safePersistence.deleteFlossRecord(record)
        
        // has any other record for today?
        if shouldRemovePendingDailyStreakNotification(ifRemove: record) {
            notificationService?.clearPendingDailyStreakFlossReminderNotification()
        }
        
        loadRecords()
    }
    
    
    func shouldRemovePendingDailyStreakNotification(ifRemove record: FlossRecord) -> Bool {
        
        if !Calendar.current.isDateInToday(record.date) {
            return false
        }
        
        let remainingRecords: [FlossRecord] = self.records.filter({$0 != record })
        let recordDaySignature = record.date.dayAndMonthAndYearFormatted
        var uniqueLogDays: Set<String> = Set()
        
        remainingRecords.forEach { log in
            let logDaySignature = log.date.dayAndMonthAndYearFormatted
            
            uniqueLogDays.insert(logDaySignature)
        }
        
        if uniqueLogDays.contains(recordDaySignature) {
            return false
        } else {
            return true
        }
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

