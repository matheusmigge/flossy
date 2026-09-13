//
//  AddLogRecordUseCase.swift
//  DidIFloss
//

import Foundation
import FlossyData
import FlossyReminders

public enum AddLogError: Error {
    case dateInFuture
    case failedToSave
}

public protocol AddLogRecordUseCaseProtocol: Sendable {
    func isDateValid(_ date: Date) -> Bool
    func execute(date: Date) async throws
}

public struct AddLogRecordUseCase: AddLogRecordUseCaseProtocol {
    
    public let recordsRepository: any FlossLogRepository
    public let notificationService: FlossyRemindersService
    public let streakAnalyzer: any StreakAnalyzer
    
    public init(
        recordsRepository: any FlossLogRepository = DefaultFlossLogRepositoryFactory.make(),
        notificationService: FlossyRemindersService = FlossyRemindersServiceFactory.make(),
        streakAnalyzer: any StreakAnalyzer = DefaultStreakAnalyzer()
    ) {
        self.recordsRepository = recordsRepository
        self.notificationService = notificationService
        self.streakAnalyzer = streakAnalyzer
    }
    
    public func isDateValid(_ date: Date) -> Bool {
        return date <= .now
    }
    
    public func execute(date: Date) async throws {
        guard isDateValid(date) else {
            throw AddLogError.dateInFuture
        }
        
        var dateToSave = date
        
        // formats date if needed (e.g. if logging for a previous day, sets time to current time)
        if !Calendar.current.isDateInToday(dateToSave) {
            let calendarComponents = Calendar.current.dateComponents([.year, .month, .day], from: dateToSave)
            let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: .now)
            
            dateToSave = Calendar.createDate(year: calendarComponents.year, month: calendarComponents.month, day: calendarComponents.day, hour: timeComponents.hour, minute: timeComponents.minute) ?? date
        }
        
        do {
            try await recordsRepository.addLog(FlossLog(flossDate: dateToSave))
            try await scheduleNotifications(flossDate: dateToSave)
        } catch {
            throw AddLogError.failedToSave 
        }
    }
    
    private func scheduleNotifications(flossDate date: Date) async throws {
        if Calendar.current.isDateInToday(date) {
            let records = try await recordsRepository.fetchLogs()
            let state = streakAnalyzer.analyze(logDates: records.map { $0.date })
            let streakCount = StreakReminderPolicy.completedStreakCount(from: state)
            notificationService.scheduleAllFlossReminders(streakCount: streakCount)
        } else {
            notificationService.scheduleInactivityFlossReminderNotifications()
        }
    }
}

public extension AddLogRecordUseCase {
    struct StreakReminderPolicy {
        public static func completedStreakCount(from state: StreakState) -> Int {
            switch state {
            case .startedToday: return 1
            case .activeCompletedToday(days: let days): return days
            default: return 0
            }
        }
    }
}
