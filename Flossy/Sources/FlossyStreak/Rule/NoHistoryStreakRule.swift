//
//  NoHistoryStreakRule.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 27/06/26.
//


struct NoHistoryStreakRule: StreakRule {
    func resolve(context: StreakContext) -> StreakState? {
        context.loggedDays.isEmpty ? .noHistory : nil
    }
}