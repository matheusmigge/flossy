//
//  StartedTodayStreakRuleTests.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 28/06/26.
//

import Testing
@testable import FlossyStreak
import Foundation

@Suite("StartedTodayStreakRule Testing")
struct StartedTodayStreakRuleTest {
    
    private var today: Date { Date() }
    private func date(daysAgo: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -daysAgo, to: today)!
    }
    
    @Test("Resolve should return startedToday if has log today but not yesterday")
    func resolve_loggedTodayNotYesterday_returnStartedToday() {
        // Given
        let context = StreakContext(loggedDates: [today], today: today)
        let sut = StartedTodayStreakRule()
        
        // When
        let result = sut.resolve(context: context)
        
        // Then
        #expect(result == .startedToday)
    }
    
    @Test("Resolve should return nil if has log today AND yesterday")
    func resolve_loggedTodayAndYesterday_returnNil() {
        // Given
        let yesterday = date(daysAgo: 1)
        let context = StreakContext(loggedDates: [today, yesterday], today: today)
        let sut = StartedTodayStreakRule()
        
        // When
        let result = sut.resolve(context: context)
        
        // Then
        #expect(result == nil)
    }
    
    @Test("Resolve should return nil if does not have log today")
    func resolve_noLogToday_returnNil() {
        // Given
        let yesterday = date(daysAgo: 1)
        let context = StreakContext(loggedDates: [yesterday], today: today)
        let sut = StartedTodayStreakRule()
        
        // When
        let result = sut.resolve(context: context)
        
        // Then
        #expect(result == nil)
    }
}
