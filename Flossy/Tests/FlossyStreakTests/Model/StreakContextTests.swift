//
//  StreakContextTests.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 28/06/26.
//

import Testing
import Foundation
@testable import FlossyStreak

@Suite("StreakContext Testing")
struct StreakContextTests {
    
    let calendar = Calendar.current
    let referenceToday: Date = {
        var components = DateComponents()
        components.year = 2026
        components.month = 6
        components.day = 28
        components.hour = 12
        components.minute = 0
        return Calendar.current.date(from: components)!
    }()
    
    // MARK: - Helpers
    private func makeDate(daysAgo: Int, hourOffset: Int = 0) -> Date {
        let dayDate = calendar.date(byAdding: .day, value: -daysAgo, to: referenceToday)!
        return calendar.date(byAdding: .hour, value: hourOffset, to: dayDate)!
    }
    
    // MARK: - Tests
    
    @Test("Should filter out future dates and normalize remaining dates to the start of the day")
    func shouldFilterFutureDates_whenInitializing() {
        // Given
        let futureDate = makeDate(daysAgo: -2) // 2 days in the future
        let todayMorning = makeDate(daysAgo: 0, hourOffset: -5)
        let todayNight = makeDate(daysAgo: 0, hourOffset: +5)
        let yesterday = makeDate(daysAgo: 1)
        
        let logs = [futureDate, todayMorning, todayNight, yesterday]
        
        // When
        let sut = StreakContext(loggedDates: logs, today: referenceToday, calendar: calendar)
        
        // Then
        // Expecting only 2 unique dates (yesterday and today), future removed, and duplicates merged.
        #expect(sut.loggedDays.count == 2)
        #expect(sut.loggedDays.contains(calendar.startOfDay(for: yesterday)))
        #expect(sut.loggedDays.contains(calendar.startOfDay(for: referenceToday)))
    }
    
    @Test("Should correctly calculate exactly one day before the provided today")
    func shouldReturnYesterday_whenRequested() {
        // Given
        let sut = StreakContext(loggedDates: [], today: referenceToday, calendar: calendar)
        let expectedYesterday = calendar.date(byAdding: .day, value: -1, to: sut.today)!
        
        // Then
        #expect(sut.yesterday == expectedYesterday)
    }
    
    @Test("Should return the most recent date in the logged days set")
    func shouldReturnLastLoggedDay_whenSetIsNotEmpty() {
        // Given
        let yesterday = makeDate(daysAgo: 1)
        let threeDaysAgo = makeDate(daysAgo: 3)
        let sut = StreakContext(loggedDates: [threeDaysAgo, yesterday], today: referenceToday, calendar: calendar)
        
        // When
        let lastLogged = sut.lastLoggedDay
        
        // Then
        #expect(lastLogged == calendar.startOfDay(for: yesterday))
    }
    
    @Test("Should return nil for last logged day if the history is empty")
    func shouldReturnNilForLastLoggedDay_whenSetIsEmpty() {
        let sut = StreakContext(loggedDates: [], today: referenceToday, calendar: calendar)
        #expect(sut.lastLoggedDay == nil)
    }
    
    @Test("Should return true for hasLog regardless of the time of day the check is performed against")
    func shouldReturnTrueForHasLog_whenDateMatchesIgnoringTime() {
        // Given
        let twoDaysAgoAtNoon = makeDate(daysAgo: 2, hourOffset: 0)
        let sut = StreakContext(loggedDates: [twoDaysAgoAtNoon], today: referenceToday, calendar: calendar)
        
        // When
        let queryDateAtNight = makeDate(daysAgo: 2, hourOffset: 8)
        let queryMissingDate = makeDate(daysAgo: 3)
        
        
        // Then
        #expect(sut.hasLog(on: queryDateAtNight))
        #expect(!sut.hasLog(on: queryMissingDate))
    }
    
    @Test("Should correctly count consecutive backward logs starting from a specific date")
    func shouldCountConsecutiveDays_whenStreakExists() {
        // Given
        let today = makeDate(daysAgo: 0)
        let yesterday = makeDate(daysAgo: 1)
        let twoDaysAgo = makeDate(daysAgo: 2)
        let fourDaysAgo = makeDate(daysAgo: 4) // Gap at 3 days ago
        
        let sut = StreakContext(
            loggedDates: [today, yesterday, twoDaysAgo, fourDaysAgo],
            today: referenceToday,
            calendar: calendar
        )
        
        // When counting from today, it should see today, yesterday, and 2 days ago (Total: 3).
        // It should stop at the gap (3 days ago).
        let streakFromToday = sut.countContinousLoggedDays(endingAt: today)
        
        // When counting from yesterday, it should see yesterday and 2 days ago (Total: 2).
        let streakFromYesterday = sut.countContinousLoggedDays(endingAt: yesterday)
        
        // Then
        #expect(streakFromToday == 3)
        #expect(streakFromYesterday == 2)
    }
    
    @Test("Should return zero for continuous streak if there is no log on the starting check date")
    func shouldReturnZeroForConsecutiveDays_whenStartingDateHasNoLog() {
        // Given logs yesterday and two days ago, but NOT today.
        let yesterday = makeDate(daysAgo: 1)
        let twoDaysAgo = makeDate(daysAgo: 2)
        
        let sut = StreakContext(
            loggedDates: [yesterday, twoDaysAgo],
            today: referenceToday,
            calendar: calendar
        )
        
        // When checking continuous days ending TODAY (which is empty)
        let streak = sut.countContinousLoggedDays(endingAt: referenceToday)
        
        // Then
        #expect(streak == 0)
    }
    
    @Test("Should return the correct integer difference in days between a past date and today")
    func shouldCalculateDaysSince_whenGivenAPastDate() {
        // Given
        let fiveDaysAgo = makeDate(daysAgo: 5)
        let sut = StreakContext(loggedDates: [], today: referenceToday, calendar: calendar)
        
        // When
        let daysSince = sut.countDaysSince(fiveDaysAgo)
        
        // Then
        #expect(daysSince == 5)
    }
}
