//
//  HandleLogInteractionUseCase.swift
//  DidIFloss
//
//  Created by Lucas Migge on 26/03/24.
//

import Foundation
import FlossyRecords
import FlossyReminders

/// A protocol that defines the use case for handling interactions with flossing log records.
protocol HandleLogInteractionUseCaseProtocol {
    
    /// Handles logging a new floss record for a specified date.
    ///
    /// - Parameter date: The date to log the floss record.
    func handleLogRecord(for date: Date)
    
    /// Removes a specific floss record.
    ///
    /// - Parameter record: The `FlossRecord` to be removed.
    func removeLogRecord(for record: FlossLog)
    
    /// Removes all floss records associated with a specific date.
    ///
    /// - Parameter date: The date for which all records should be removed.
    func removeAllLogRecords(for date: Date)
}


/// A use case struct responsible for managing interactions with flossing log records.
///
/// The `HandleLogInteractionUseCase` handles operations such as logging a new floss record,
/// removing a specific floss record, and removing all records for a given date.
/// It interacts with a `PersistenceManagerProtocol` to manage data persistence and
/// a `FlossRemindersService` to handle scheduling and clearing reminders.
struct HandleLogInteractionUseCase: HandleLogInteractionUseCaseProtocol {
    
    let recordsRepository: any FlossLogRepository
    let notificationService: FlossyRemindersService
    let hapticsManager: HapticsManagerProtocol
    
    init(recordsRepository: any FlossLogRepository = DefaultFlossLogRepositoryFactory.make(),
         notificationService: FlossyRemindersService = FlossyRemindersServiceFactory.make(),
         hapticsManager: HapticsManagerProtocol = HapticsManager()
    ) {
        self.recordsRepository = recordsRepository
        self.notificationService = notificationService
        self.hapticsManager = hapticsManager
    }
    
    func handleLogRecord(for log: Date) {
        Task {
            var date: Date = log
            
            // formats date if needed
            if !Calendar.current.isDateInToday(date) {
                let calendarComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
                let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: .now)
                
                date = Calendar.createDate(year: calendarComponents.year, month: calendarComponents.month, day: calendarComponents.day, hour: timeComponents.hour, minute: timeComponents.minute) ?? log
            }
            
            hapticsManager.vibrateAddLogCelebration()
            try? await recordsRepository.addLog(FlossLog(flossDate: date))
            scheduleNotifications(flossDate: date)
        }
    }
    
    func removeLogRecord(for record: FlossLog) {
        Task {
            try? await recordsRepository.deleteLog(id: record.id)
            
            // has any other record for today?
            shouldRemovePendingDailyStreakNotification(ifRemove: record)
        }
    }
    
    func removeAllLogRecords(for date: Date) {
        Task {
            try? await recordsRepository.deleteLogs(on: date)
            hapticsManager.vibrateLogRemoval()
            
            if Calendar.current.isDateInToday(date) {
                self.notificationService.clearPendingDailyStreakFlossReminderNotification()
            }
        }
        
    }
    
    private func scheduleNotifications(flossDate date: Date) {
        if Calendar.current.isDateInToday(date) {
            Task {
                guard let records = try? await recordsRepository.fetchLogs() else { return }
                let streakInfo = StreakCalculator.calculateCurrentStreak(logsDates: records.map({ $0.date }))
                notificationService.scheduleAllFlossReminders(streakCount: streakInfo.days)
            }
            
        } else {
            notificationService.scheduleInactivityFlossReminderNotifications()
        }
    }
    
    private func shouldRemovePendingDailyStreakNotification(ifRemove record: FlossLog) {
        
        if !Calendar.current.isDateInToday(record.date) {
            return
        }
        
        let recordDaySignature = record.date.calendarSignature
        var uniqueLogDays: Set<String> = Set()
        
        Task {
            guard let records = try? await recordsRepository.fetchLogs() else { return }
            let remainingRecords: [FlossLog] = records.filter({$0.id != record.id})
            
            remainingRecords.forEach { log in
                let logDaySignature = log.date.calendarSignature
                
                uniqueLogDays.insert(logDaySignature)
            }
            
            if !uniqueLogDays.contains(recordDaySignature) {
                notificationService.clearPendingDailyStreakFlossReminderNotification()
            }
        }
    }
}
