//
//  FlossyStreakAnalizer.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 27/06/26.
//

import Foundation

public protocol StreakAnalyzer {
    func analyze(
        logDates: [Date],
        referenceDate: Date,
        calendar: Calendar
    ) -> StreakState
}

public extension StreakAnalyzer {
    func analyze(logDates: [Date]) -> StreakState {
        analyze(logDates: logDates, referenceDate: .now, calendar: .current)
    }
}

public struct DefaultStreakAnalyzer {
    
    let rules: [any StreakRule]
    
    public init() {
        self.rules = .defaultRules
    }
    
    init(rules: [any StreakRule]) {
        self.rules = rules
    }
}

extension DefaultStreakAnalyzer: StreakAnalyzer {
    public func analyze(
        logDates: [Date],
        referenceDate: Date = .now,
        calendar: Calendar = .current
    ) -> StreakState {
        let context = StreakContext(
                    loggedDates: logDates,
                    today: referenceDate,
                    calendar: calendar
                )
                return self.analyze(context)
    }
    
    func analyze(_ context: StreakContext) -> StreakState {
        for rule in self.rules {
            if let state = rule.resolve(context: context) {
                return state
            }
        }
        
        return .noHistory
    }
}
