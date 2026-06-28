//
//  InactiveStreakRuleTests.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 28/06/26.
//

import Testing
@testable import FlossyStreak
import Foundation

@Suite("InactiveStreakRule Testing")
struct InactiveStreakRuleTests {
    
    private var today: Date { Date() }
    private func date(daysAgo: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -daysAgo, to: today)!
    }
    
    @Test("Resolve should return inactive with correct days if no log today or yesterday")
    func resolve_noLogTodayOrYesterday_returnInactive() {
        // Given
        let threeDaysAgo = date(daysAgo: 3)
        let context = StreakContext(loggedDates: [threeDaysAgo], today: today)
        let sut = InactiveStreakRule()
        
        // When
        let result = sut.resolve(context: context)
        
        // Then
        #expect(result == .inactive(daysSinceLastLog: 3))
    }
    
    @Test("Resolve should return nil if has log today")
    func resolve_hasLogToday_returnNil() {
        // Given
        let threeDaysAgo = date(daysAgo: 3)
        let context = StreakContext(loggedDates: [today, threeDaysAgo], today: today)
        let sut = InactiveStreakRule()
        
        // When
        let result = sut.resolve(context: context)
        
        // Then
        #expect(result == nil)
    }
    
    @Test("Resolve should return nil if has log yesterday")
    func resolve_hasLogYesterday_returnNil() {
        // Given
        let yesterday = date(daysAgo: 1)
        let context = StreakContext(loggedDates: [yesterday], today: today)
        let sut = InactiveStreakRule()
        
        // When
        let result = sut.resolve(context: context)
        
        // Then
        #expect(result == nil)
    }
    
    @Test("Resolve should return nil if loggedDays is empty")
    func resolve_emptyLoggedDays_returnNil() {
        // Given
        let context = StreakContext(loggedDates: [], today: today)
        let sut = InactiveStreakRule()
        
        // When
        let result = sut.resolve(context: context)
        
        // Then
        #expect(result == nil)
    }
}
