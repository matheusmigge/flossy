//
//  StreakCalculatorTests.swift
//  DidIFlossTests
//
//  Created by Lucas Migge on 20/02/24.
//

import XCTest
@testable import DidIFloss

final class StreakCalculatorTests: XCTestCase {
    func testCalculateStreakReturnsExpectedResultWhenUserHasNoLogs() {
        
        let logs: [Date] = []
        
        let result = StreakCalculator.calculateCurrentStreak(logsDates: logs)
        
        XCTAssertEqual(result.streak, StreakInfo.Streak.empty)
        
    }
    
    func testCalculateStreakReturnsExpectedResultWhenUserHasFlossStreakButDidntFlossToday() {
        
        let logs: [Date] = [Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                            Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
                            Calendar.current.date(byAdding: .day, value: -3, to: Date())!]
        
        let result = StreakCalculator.calculateCurrentStreak(logsDates: logs)
        
        XCTAssertEqual(result.streak, StreakInfo.Streak.positiveMissingToday)
        XCTAssertEqual(result.days, 3)
        
    }
    
    func testCalculateStreakReturnsExpectedResultWhenUserHasCompleteFlossStreak() {
        let logs: [Date] = [Date(),
                            Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                            Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
                            Calendar.current.date(byAdding: .day, value: -3, to: Date())!]
        
        let result = StreakCalculator.calculateCurrentStreak(logsDates: logs)
        
        XCTAssertEqual(result.streak, StreakInfo.Streak.positive)
        XCTAssertEqual(result.days, 4)
    }
    
    func testCalculateStreakReturnsExpectedResultWhenUserHasMoreThanARecordPerDay() {
        let logs: [Date] = [Date(),
                            Date(),
                            Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                            Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
                            Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
                            Calendar.current.date(byAdding: .day, value: -3, to: Date())!]
        
        let result = StreakCalculator.calculateCurrentStreak(logsDates: logs)
        
        XCTAssertEqual(result.streak, StreakInfo.Streak.positive)
        XCTAssertEqual(result.days, 4)
    }
    
    func testCalculateStreakReturnsExpectedResultWhenUserHasMissingFlossStreak() {
        
        let logs: [Date] = [Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
                            Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
        ]
        
        let result = StreakCalculator.calculateCurrentStreak(logsDates: logs)
        
        XCTAssertEqual(result.streak, StreakInfo.Streak.negative)
        XCTAssertEqual(result.days, 3)
        
    }
    
    
    func testCalculateCurrentStreakReturnsEmptyStateWhenNoRecords() {
        let dates: [Date] = []
        
        let result = StreakCalculator.calculateCurrentStreak(logsDates: dates)
        
        XCTAssertEqual(result.streak, StreakInfo.Streak.empty)
    }
    
    func testCalculateCurrentStreakReturnsCorrespondingPositiveStreak() {
        
        var dates: [Date] { [
            Calendar.current.date(byAdding: .day, value: -3, to: .now)!,
            Calendar.current.date(byAdding: .day, value: -3, to: .now)!,
            Calendar.current.date(byAdding: .day, value: -2, to: .now)!,
            Calendar.current.date(byAdding: .day, value: -1, to: .now)!,
            Date()
        ]
        }
        
        let result = StreakCalculator.calculateCurrentStreak(logsDates: dates)
        
        XCTAssertEqual(result.streak, StreakInfo.Streak.positive)
        XCTAssertEqual(result.days, 4)
        
    }
    
    func testCalculateCurrentStreakReturnsPositiveMissingToday() {
        var dates: [Date] { [
            Calendar.current.date(byAdding: .day, value: -3, to: .now)!,
            Calendar.current.date(byAdding: .day, value: -3, to: .now)!,
            Calendar.current.date(byAdding: .day, value: -2, to: .now)!,
            Calendar.current.date(byAdding: .day, value: -1, to: .now)!,
    
        ]
        }
        
        let result = StreakCalculator.calculateCurrentStreak(logsDates: dates)
        
        XCTAssertEqual(result.streak, StreakInfo.Streak.positiveMissingToday)
        XCTAssertEqual(result.days, 3)
    }
    
    func testCalculateCurrentStreakReturnsNegativeStreak() {
        var dates: [Date] { [
            Calendar.current.date(byAdding: .day, value: -7, to: .now)!,
            Calendar.current.date(byAdding: .day, value: -8, to: .now)!,
            Calendar.current.date(byAdding: .day, value: -9, to: .now)!,
            Calendar.current.date(byAdding: .day, value: -10, to: .now)!
        ]
        }
        
        let result = StreakCalculator.calculateCurrentStreak(logsDates: dates)
        
        XCTAssertEqual(result.streak, StreakInfo.Streak.negative)
        XCTAssertEqual(result.days, 7)
    }
    

    
}

