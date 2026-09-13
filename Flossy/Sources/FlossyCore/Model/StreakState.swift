//
//  StreakState.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 27/06/26.
//


public enum StreakState: Equatable, Sendable {
    case noHistory
    case startedToday
    case activeCompletedToday(days: Int)
    case activePendingToday(days: Int)
    case inactive(daysSinceLastLog: Int)
}

