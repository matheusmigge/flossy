//
//  HandleLogInteractionUseCase.swift
//  DidIFloss
//
//  Created by Lucas Migge on 26/03/24.
//

import Foundation
import Notification

protocol HandleLogInteractionUseCaseProtocol {
    func handleLogRecord(for date: Date)
    
    func removeLogRecord(for record: FlossRecord)
    
    func removeAllLogRecords(for date: Date)
}

struct HandleLogInteractionUseCase: HandleLogInteractionUseCaseProtocol {
    
    let recordsRepository: PersistenceManagerProtocol
    let notificationService: FlossRemindersService
    
    init(recordsRepository: PersistenceManagerProtocol = PersistenceManager.shared,
         notificationService: FlossRemindersService = NotificationService.current()
    ) {
        self.recordsRepository = recordsRepository
        self.notificationService = notificationService
    }
    
    func handleLogRecord(for log: Date) {
        
        var date: Date = log
        
        // formats date if needed
        if !Calendar.current.isDateInToday(date) {
            let calendarComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
            let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: .now)
            
            date = Calendar.createDate(year: calendarComponents.year, month: calendarComponents.month, day: calendarComponents.day, hour: timeComponents.hour, minute: timeComponents.minute) ?? log
        }
        
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
