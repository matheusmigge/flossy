//
//  InactiveStreakRule.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 27/06/26.
//


struct InactiveStreakRule: StreakRule {
    func resolve(context: StreakContext) -> StreakState? {
        let hasLogToday = context.hasLog(on: context.today)
        let hasLogYesterday = context.hasLog(on: context.yesterday)
        
        guard let lastLoggedDay = context.lastLoggedDay, !hasLogToday, !hasLogYesterday else {
            return nil
        }
        
        let daysSinceLastLog = context.countDaysSince(lastLoggedDay)
        return .inactive(daysSinceLastLog: daysSinceLastLog)
    }
}
