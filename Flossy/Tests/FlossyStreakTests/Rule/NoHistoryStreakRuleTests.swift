//
//  NoHistoryStreakRuleTests.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 28/06/26.
//

import Testing
@testable import FlossyStreak
import Foundation

@Suite("NoHistoryStreakRule Testing")
struct NoHistoryStreakRuleTests {
    
    @Test("Resolve should return no historiy if logged days is empty")
    func resolve_emptyLoggedDays_returnNoHistory() {
        // Given
        let noLoggedDaysContext = StreakContext(loggedDates: [], today: .now)
        let sut = NoHistoryStreakRule()
        
        // When
        let result = sut.resolve(context: noLoggedDaysContext)
        
        // Then
        #expect(result == .noHistory)
    }
    
    @Test("Resolve should return nil if has logged days")
    func resolve_hasLoggedDays_returnNil() {
        // given
        let hasLoggedDaysContext = StreakContext(loggedDates: [Date()], today: .now)
        let sut = NoHistoryStreakRule()
        
        // when
        let result = sut.resolve(context: hasLoggedDaysContext)
        
        // Then
        #expect(result == nil)
    }
}
