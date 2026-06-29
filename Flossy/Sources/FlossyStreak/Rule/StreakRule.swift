//
//  StreakRule.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 27/06/26.
//


protocol StreakRule {
    func resolve(context: StreakContext) -> StreakState?
}

extension Array where Element == any StreakRule {
    static var defaultRules: [any StreakRule] {
        [
            NoHistoryStreakRule(),
            ActiveCompletedTodayStreakRule(),
            ActivePendingTodayStreakRule(),
            StartedTodayStreakRule(),
            InactiveStreakRule()
        ]
    }
}
