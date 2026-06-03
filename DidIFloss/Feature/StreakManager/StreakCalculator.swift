//
//  StreakCalculator.swift
//  DidIFloss
//
//  Created by Lucas Migge on 20/02/24.
//

import Foundation

struct StreakCalculator {
    
    public static func createStreakBoardViewModel(info: StreakInfo) -> StreakBoardViewModel {
        switch info.streak {
        case .positive:
            return StreakBoardViewModel(streakBoardContent: .positiveStreak(count: info.days),
                                        warmingBoardContent: .userHadLoggedToday)
        case .positiveMissingToday:
            return StreakBoardViewModel(streakBoardContent: .positiveStreak(count: info.days),
                                        warmingBoardContent: .userHasPositiveStreak)
        case .negative:
            if info.days < 3 {
                return StreakBoardViewModel(streakBoardContent: .shortNegativeStreak,
                                            warmingBoardContent: .userHasNegativeStreak)
            } else {
                return StreakBoardViewModel(streakBoardContent: .longNegativeStreak(count: info.days),
                                            warmingBoardContent: .userHasNegativeStreak)
            }
        case .empty:
            return StreakBoardViewModel(streakBoardContent: .noLogsRecorded,
                                        warmingBoardContent: .noLogsRecorded)
        }
    }
    
    
    public static func calculateCurrentStreak(logsDates: [Date]) -> StreakInfo {
        let logDaysSet = getLogDaysSet(from: logsDates)
        
        guard let lastLogDate = logsDates.first else {
            return StreakInfo(streak: .empty, days: 0)
        }
    
        
        if let (didFlossToday, streakCount) = calculateStreak(logDaysSet: logDaysSet) {
            // is positive
            return StreakInfo(streak: didFlossToday ? .positive : .positiveMissingToday, days: streakCount)
            
        } else {
            // is negative
            let daysCount = calculateDaysSinceLastLog(from: lastLogDate)
            return StreakInfo(streak: .negative, days: daysCount)
            
        }
    }
    
    private static func getLogDaysSet(from logsDates: [Date]) -> Set<String> {
        return Set(logsDates.map { $0.calendarSignature })
    }
    
    private static func calculateStreak(logDaysSet: Set<String>) -> (didFlossToday: Bool, streakCount: Int)? {
        let todaySignature = Calendar.today.calendarSignature
        let yesterdaySignature = Calendar.yesterday.calendarSignature
        
        if logDaysSet.contains(todaySignature) || logDaysSet.contains(yesterdaySignature) {
            var didFlossToday = false
            var streakCount = 0
            
            if logDaysSet.contains(todaySignature) {
                didFlossToday = true
                streakCount += 1
            }
            
            for index in 1...logDaysSet.count {
                let referenceDate = Calendar.current.date(byAdding: .day, value: -index, to: Date())!
                let referenceDateSignature = referenceDate.calendarSignature
                
                if logDaysSet.contains(referenceDateSignature) {
                    streakCount += 1
                } else {
                    break
                }
            }
            
            return (didFlossToday, streakCount)
            
        } else {
            return nil
        }
    }
    
    private static func calculateDaysSinceLastLog(from date: Date) -> Int {
        let daysCount = Calendar.current.dateComponents([.day], from: date, to: Date())
        return daysCount.day ?? 0
    }
}



