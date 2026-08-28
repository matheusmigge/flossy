//
//  RemoveLogRecordUseCase.swift
//  DidIFloss
//

import Foundation
import FlossyData
import FlossyReminders

protocol RemoveLogRecordUseCaseProtocol {
    func execute(record: FlossLog) async throws
    func execute(removeAllFor date: Date) async throws
}

struct RemoveLogRecordUseCase: RemoveLogRecordUseCaseProtocol {
    
    let recordsRepository: any FlossLogRepository
    let notificationService: FlossyRemindersService
    let hapticsManager: HapticsManagerProtocol
    
    init(
        recordsRepository: any FlossLogRepository = DefaultFlossLogRepositoryFactory.make(),
        notificationService: FlossyRemindersService = FlossyRemindersServiceFactory.make(),
        hapticsManager: HapticsManagerProtocol = HapticsManager()
    ) {
        self.recordsRepository = recordsRepository
        self.notificationService = notificationService
        self.hapticsManager = hapticsManager
    }
    
    func execute(record: FlossLog) async throws {
        try await recordsRepository.deleteLog(id: record.id)
        
        await MainActor.run {
            hapticsManager.vibrateLogRemoval()
        }
        
        try await shouldRemovePendingDailyStreakNotification(ifRemove: record)
    }
    
    func execute(removeAllFor date: Date) async throws {
        try await recordsRepository.deleteLogs(on: date)
        
        await MainActor.run {
            hapticsManager.vibrateLogRemoval()
        }
        
        if Calendar.current.isDateInToday(date) {
            notificationService.clearPendingDailyStreakFlossReminderNotification()
        }
    }
    
    private func shouldRemovePendingDailyStreakNotification(ifRemove record: FlossLog) async throws {
        if !Calendar.current.isDateInToday(record.date) {
            return
        }
        
        let recordDaySignature = record.date.calendarSignature
        var uniqueLogDays: Set<String> = Set()
        
        let records = try await recordsRepository.fetchLogs()
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
