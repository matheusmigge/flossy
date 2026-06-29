//
//  DefaultStreakAnalyzerTests.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 28/06/26.
//

import Foundation
import Testing
@testable import FlossyStreak

@Suite("DefaultStreakAnalyzer Testing")
struct DefaultStreakAnalyzerTests {
    
    final class MockStreakRule: StreakRule {
        let result: StreakState?
        var resolveCallCount: Int
        var capturedContext: StreakContext?
        
        init(result: StreakState?) {
            self.result = result
            self.resolveCallCount = 0
        }
        
        func resolve(context: StreakContext) -> StreakState? {
            resolveCallCount += 1
            capturedContext = context
            return result
        }
    }
    
    var anyContext: StreakContext {
        .init(loggedDates: [], today: .now)
    }
    
    @Test("Analyze should return first resolved rule")
    func testAnalyzeShouldReturnFirstResolvedRule() {
        // given
        let sut = DefaultStreakAnalyzer(rules: [
            MockStreakRule(result: .activePendingToday(days: 5)),
            MockStreakRule(result: nil),
            MockStreakRule(result: .inactive(daysSinceLastLog: 5))
        ])
        
        // When
        let result = sut.analyze(anyContext)
        
        
        // Then
        #expect(result == .activePendingToday(days: 5))
    }
    
    @Test("Analyze should ignore unresolved rules")
    func testAnalyzeShouldIgnoreUnresolvedRules() {
        // Given
        let sut = DefaultStreakAnalyzer(rules: [
            MockStreakRule(result: nil),
            MockStreakRule(result: nil),
            MockStreakRule(result: nil),
            MockStreakRule(result: .inactive(daysSinceLastLog: 5))
        ])
        
        // When
        let result = sut.analyze(anyContext)
        
        #expect(result == .inactive(daysSinceLastLog: 5))
    }
    
    @Test("Analyze should return noHistory as fallback when no rule resolves")
    func testAnalyzeShouldReturnNoHistoryWhenNoRuleResolves() {
        // Given
        let sut = DefaultStreakAnalyzer(rules: [
            MockStreakRule(result: nil),
            MockStreakRule(result: nil),
            MockStreakRule(result: nil)
        ])
        
        // When
        let result = sut.analyze(anyContext)
        
        // Then
        #expect(result == .noHistory)
    }
    
    @Test("Analyze should stop as soon as first rule is resolved")
    func testAnalyzeShouldStopAsSoonAsFirstRuleIsResolved() {
        // Given
        let unresolvedRule = MockStreakRule(result: nil)
        let resolvedRule = MockStreakRule(result: .activePendingToday(days: 5))
        let ruleResolvedAfter = MockStreakRule(result: .inactive(daysSinceLastLog: 5))
        
        let sut = DefaultStreakAnalyzer(rules: [
            unresolvedRule,
            resolvedRule,
            ruleResolvedAfter
        ])
        
        // When
        let result = sut.analyze(anyContext)
        
        // Then
        #expect(result == .activePendingToday(days: 5))
        #expect(unresolvedRule.resolveCallCount == 1)
        #expect(resolvedRule.resolveCallCount == 1)
        #expect(ruleResolvedAfter.resolveCallCount == 0)
    }
    
    @Test("Should pass injected dependencies to StreakContext correctly")
    func shouldPassInjectedDependencies_toContext() {
        // Given
        let spyRule = MockStreakRule(result: .noHistory, )
        let sut = DefaultStreakAnalyzer(rules: [spyRule])
        
        var customCalendar = Calendar(identifier: .gregorian)
        customCalendar.timeZone = TimeZone(secondsFromGMT: 0)!
        
        let customReferenceDate = Date(timeIntervalSince1970: 1000000)
        let logDate1 = Date(timeIntervalSince1970: 900000)
        let logDate2 = Date(timeIntervalSince1970: 800000)
        let customLogDates = [logDate1, logDate2]
        
        // When
        _ = sut.analyze(
            logDates: customLogDates,
            referenceDate: customReferenceDate,
            calendar: customCalendar
        )
        
        // Then
        guard let capturedContext = spyRule.capturedContext else {
            Issue.record("Context should not be nil")
            return
        }
        
        #expect(capturedContext.calendar == customCalendar)
        let expectedToday = customCalendar.startOfDay(for: customReferenceDate)
        #expect(capturedContext.today == expectedToday)
        
        let expectedLog1 = customCalendar.startOfDay(for: logDate1)
        let expectedLog2 = customCalendar.startOfDay(for: logDate2)
        #expect(capturedContext.loggedDays.contains(expectedLog1))
        #expect(capturedContext.loggedDays.contains(expectedLog2))
    }
    
}
