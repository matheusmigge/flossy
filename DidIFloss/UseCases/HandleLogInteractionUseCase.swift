//
//  HandleLogInteractionUseCase.swift
//  DidIFloss
//
//  Created by Lucas Migge on 26/03/24.
//

import Foundation
import FlossyNotification

/// A protocol that defines the use case for handling interactions with flossing log records.
protocol HandleLogInteractionUseCaseProtocol {
    
    /// Handles logging a new floss record for a specified date.
    ///
    /// - Parameter date: The date to log the floss record.
    func handleLogRecord(for date: Date)
    
    /// Removes a specific floss record.
    ///
    /// - Parameter record: The `FlossRecord` to be removed.
    func removeLogRecord(for record: FlossRecord)
    
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
    
    let recordsRepository: PersistenceManagerProtocol
    let notificationService: FlossRemindersService
    let hapticsManager: HapticsManagerProtocol
    
    init(recordsRepository: PersistenceManagerProtocol = PersistenceManager.shared,
         notificationService: FlossRemindersService = NotificationService.current(),
         hapticsManager: HapticsManagerProtocol = HapticsManager()
    ) {
        self.recordsRepository = recordsRepository
        self.notificationService = notificationService
        self.hapticsManager = hapticsManager
    }
    
    func handleLogRecord(for log: Date) {
        
        var date: Date = log
        
        // formats date if needed
        if !Calendar.current.isDateInToday(date) {
            let calendarComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
            let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: .now)
            
            date = Calendar.createDate(year: calendarComponents.year, month: calendarComponents.month, day: calendarComponents.day, hour: timeComponents.hour, minute: timeComponents.minute) ?? log
        }
        
        hapticsManager.vibrateAddLogCelebration()
        recordsRepository.saveFlossDate(date: date)
        scheduleNotifications(flossDate: date)
    }
    
    func removeLogRecord(for record: FlossRecord) {
        
        recordsRepository.deleteFlossRecord(record)
        
        // has any other record for today?
        shouldRemovePendingDailyStreakNotification(ifRemove: record)
    }
    
    func removeAllLogRecords(for date: Date) {
        recordsRepository.getFlossRecords {  records in
            var selectedRecords: [FlossRecord] {
                records.filter { Calendar.current.isDate($0.date, inSameDayAs: date)}
            }
            
            self.recordsRepository.deleteFlossRecords(selectedRecords)
            hapticsManager.vibrateLogRemoval()
        }
        
        if Calendar.current.isDateInToday(date) {
            self.notificationService.clearPendingDailyStreakFlossReminderNotification()
            
        }
    }
    
    private func scheduleNotifications(flossDate date: Date) {
        if Calendar.current.isDateInToday(date) {
            self.recordsRepository.getFlossRecords { records in
                let streakInfo = StreakCalculator.calculateCurrentStreak(logsDates: records.map({$0.date}))
                self.notificationService.scheduleAllFlossReminders(streakCount: streakInfo.days)
            }
            
        } else {
            notificationService.scheduleInactivityFlossReminderNotifications()
        }
    }
    
    private func shouldRemovePendingDailyStreakNotification(ifRemove record: FlossRecord) {
        
        if !Calendar.current.isDateInToday(record.date) {
            return
        }
        
        let recordDaySignature = record.date.calendarSignature
        var uniqueLogDays: Set<String> = Set()
        
        recordsRepository.getFlossRecords { records in
            let remainingRecords: [FlossRecord] = records.filter({$0.id != record.id})
            
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
