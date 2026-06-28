//
//  DefaultStreakAnalyzerTests.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 28/06/26.
//

import Testing
@testable import FlossyStreak

@Suite("DefaultStreakAnalyzer Testing")
struct DefaultStreakAnalyzerTests {

    final class MockStreakRule: StreakRule {
        let result: StreakState?
        var resolveCallCount: Int
        
        init(result: StreakState?) {
            self.result = result
            self.resolveCallCount = 0
        }
        
        func resolve(context: StreakContext) -> StreakState? {
            resolveCallCount += 1
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
            MockStreakRule(result: .inactived(daysSinceLastLog: 5))
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
            MockStreakRule(result: .inactived(daysSinceLastLog: 5))
        ])
        
        // When
        let result = sut.analyze(anyContext)
        
        #expect(result == .inactived(daysSinceLastLog: 5))
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
        let ruleResolvedAfter = MockStreakRule(result: .inactived(daysSinceLastLog: 5))
        
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
    
    
}
