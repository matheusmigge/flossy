//
//  StartedTodayStreakRule.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 27/06/26.
//


struct StartedTodayStreakRule: StreakRule {
    func resolve(context: StreakContext) -> StreakState? {
        let hasLogToday = context.hasLog(on: context.today)
        let hasLogYesterday = context.hasLog(on: context.yesterday)
        
        guard hasLogToday, !hasLogYesterday else {
            return nil
        }
        
        return .startedToday
    }
}
