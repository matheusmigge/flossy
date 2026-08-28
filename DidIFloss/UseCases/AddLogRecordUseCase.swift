//
//  AddLogRecordUseCase.swift
//  DidIFloss
//

import Foundation
import FlossyData
import FlossyReminders
import FlossyStreak

enum AddLogError: Error {
    case dateInFuture
    case failedToSave
}

protocol AddLogRecordUseCaseProtocol {
    func isDateValid(_ date: Date) -> Bool
    func execute(date: Date) async throws
}

struct AddLogRecordUseCase: AddLogRecordUseCaseProtocol {
    
    let recordsRepository: any FlossLogRepository
    let notificationService: FlossyRemindersService
    let streakAnalyzer: any StreakAnalyzer
    let hapticsManager: HapticsManagerProtocol
    
    init(
        recordsRepository: any FlossLogRepository = DefaultFlossLogRepositoryFactory.make(),
        notificationService: FlossyRemindersService = FlossyRemindersServiceFactory.make(),
        streakAnalyzer: any StreakAnalyzer = DefaultStreakAnalyzer(),
        hapticsManager: HapticsManagerProtocol = HapticsManager()
    ) {
        self.recordsRepository = recordsRepository
        self.notificationService = notificationService
        self.streakAnalyzer = streakAnalyzer
        self.hapticsManager = hapticsManager
    }
    
    func isDateValid(_ date: Date) -> Bool {
        return date <= .now
    }
    
    func execute(date: Date) async throws {
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
            await MainActor.run {
                hapticsManager.vibrateAddLogCelebration()
            }
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

extension AddLogRecordUseCase {
    struct StreakReminderPolicy {
        static func completedStreakCount(from state: StreakState) -> Int {
            switch state {
            case .startedToday: return 1
            case .activeCompletedToday(days: let days): return days
            default: return 0
            }
        }
    }
}
