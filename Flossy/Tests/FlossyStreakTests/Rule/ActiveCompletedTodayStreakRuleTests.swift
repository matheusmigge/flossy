//
//  ActiveCompletedTodayStreakRuleTests.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 28/06/26.
//

import Testing
@testable import FlossyStreak
import Foundation

@Suite("ActiveCompletedTodayStreakRule Testing")
struct ActiveCompletedTodayStreakRuleTests {
    
    private var today: Date { Date() }
    private func date(daysAgo: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -daysAgo, to: today)!
    }
    
    @Test("Resolve should return activeCompletedToday if logged today and yesterday")
    func resolve_loggedTodayAndYesterday_returnActiveCompletedToday() {
        // Given
        let yesterday = date(daysAgo: 1)
        let twoDaysAgo = date(daysAgo: 2)
        // 3 consecutive days, ending today
        let context = StreakContext(loggedDates: [today, yesterday, twoDaysAgo], today: today)
        let sut = ActiveCompletedTodayStreakRule()
        
        // When
        let result = sut.resolve(context: context)
        
        // Then
        #expect(result == .activeCompletedToday(days: 3))
    }
    
    @Test("Resolve should return nil if does not have log today")
    func resolve_noLogToday_returnNil() {
        // Given
        let yesterday = date(daysAgo: 1)
        let context = StreakContext(loggedDates: [yesterday], today: today)
        let sut = ActiveCompletedTodayStreakRule()
        
        // When
        let result = sut.resolve(context: context)
        
        // Then
        #expect(result == nil)
    }
    
    @Test("Resolve should return nil if does not have log yesterday")
    func resolve_noLogYesterday_returnNil() {
        // Given
        let context = StreakContext(loggedDates: [today], today: today)
        let sut = ActiveCompletedTodayStreakRule()
        
        // When
        let result = sut.resolve(context: context)
        
        // Then
        #expect(result == nil)
    }
}
