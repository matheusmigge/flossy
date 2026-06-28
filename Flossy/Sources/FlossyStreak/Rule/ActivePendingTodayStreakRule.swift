//
//  ActivePendingTodayStreakRule.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 27/06/26.
//


struct ActivePendingTodayStreakRule: StreakRule {
    func resolve(context: StreakContext) -> StreakState? {
        let hasLogToday = context.hasLog(on: context.today)
        let hasLogYesteday = context.hasLog(on: context.yesterday)
        
        guard !hasLogToday, hasLogYesteday else {
            return nil
        }
        
        let daysCount = context.countContinousLoggedDays(endingAt: context.yesterday)
        return .activePendingToday(days: daysCount)
    }
}
