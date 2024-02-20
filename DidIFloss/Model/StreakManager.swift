//
//  StreakManager.swift
//  DidIFloss
//
//  Created by Lucas Migge on 20/02/24.
//

import Foundation

struct StreakManager {
    
    static func calculateCurrentStreak(logsDates: [Date]) -> StreakInfo {
        let logDaysSet = getLogDaysSet(from: logsDates)
        
        guard let firstLogDate = logsDates.first else {
            return StreakInfo(state: .empty, days: 0)
        }
        
        if let (didFlossToday, streakCount) = calculateStreak(logDaysSet: logDaysSet) {
            return StreakInfo(state: didFlossToday ? .streak : .missingToday, days: streakCount)
            
        } else {
            let daysCount = calculateDaysSinceLastLog(from: firstLogDate)
            return StreakInfo(state: .missing, days: daysCount)
            
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

struct StreakInfo {
    enum State {
        case streak, missingToday, missing, empty
    }
    
    let state: State
    let days: Int
}
