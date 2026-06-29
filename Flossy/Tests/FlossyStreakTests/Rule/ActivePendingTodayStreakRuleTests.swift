//
//  ActivePendingTodayStreakRuleTests.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 28/06/26.
//

import Testing
@testable import FlossyStreak
import Foundation

@Suite("ActivePendingTodayStreakRule Testing")
struct ActivePendingTodayStreakRuleTests {
    
    private var today: Date { Date() }
    private func date(daysAgo: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -daysAgo, to: today)!
    }
    
    @Test("Resolve should return activePendingToday if logged yesterday but not today")
    func resolve_loggedYesterdayNotToday_returnActivePendingToday() {
        // Given
        let yesterday = date(daysAgo: 1)
        let twoDaysAgo = date(daysAgo: 2)
        // 2 consecutive days, ending yesterday
        let context = StreakContext(loggedDates: [yesterday, twoDaysAgo], today: today)
        let sut = ActivePendingTodayStreakRule()
        
        // When
        let result = sut.resolve(context: context)
        
        // Then
        #expect(result == .activePendingToday(days: 2))
    }
    
    @Test("Resolve should return nil if has log today")
    func resolve_hasLogToday_returnNil() {
        // Given
        let yesterday = date(daysAgo: 1)
        let context = StreakContext(loggedDates: [today, yesterday], today: today)
        let sut = ActivePendingTodayStreakRule()
        
        // When
        let result = sut.resolve(context: context)
        
        // Then
        #expect(result == nil)
    }
    
    @Test("Resolve should return nil if does not have log yesterday")
    func resolve_noLogYesterday_returnNil() {
        // Given
        let twoDaysAgo = date(daysAgo: 2)
        let context = StreakContext(loggedDates: [twoDaysAgo], today: today)
        let sut = ActivePendingTodayStreakRule()
        
        // When
        let result = sut.resolve(context: context)
        
        // Then
        #expect(result == nil)
    }
}
