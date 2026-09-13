//
//  RemoveLogRecordUseCase.swift
//  DidIFloss
//

import Foundation
import FlossyData
import FlossyReminders

public protocol RemoveLogRecordUseCaseProtocol: Sendable {
    func execute(record: FlossLog) async throws
    func execute(removeAllFor date: Date) async throws
}

public struct RemoveLogRecordUseCase: RemoveLogRecordUseCaseProtocol {
    
    public let recordsRepository: any FlossLogRepository
    public let notificationService: FlossyRemindersService
    
    public init(
        recordsRepository: any FlossLogRepository,
        notificationService: FlossyRemindersService
    ) {
        self.recordsRepository = recordsRepository
        self.notificationService = notificationService
    }
    
    public func execute(record: FlossLog) async throws {
        try await recordsRepository.deleteLog(id: record.id)
        
        try await shouldRemovePendingDailyStreakNotification(ifRemove: record)
    }
    
    public func execute(removeAllFor date: Date) async throws {
        try await recordsRepository.deleteLogs(on: date)
        
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
