//
//  StreakContext.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 27/06/26.
//

import Foundation

struct StreakContext {
    let calendar: Calendar
    let loggedDays: Set<Date>
    let today: Date
    
    init(
        loggedDates: [Date],
        today: Date,
        calendar: Calendar = Calendar.current
    ) {
        let todayDate = calendar.startOfDay(for: today)
        self.calendar = calendar
        self.today = todayDate
        self.loggedDays = Set(
            loggedDates
                .map{ calendar.startOfDay(for: $0)}
                .filter{ $0 <= todayDate }
        )
    }
    
    var yesterday: Date {
        calendar.date(byAdding: .day, value: -1, to: today) ?? today
    }
    
    var lastLoggedDay: Date? {
        loggedDays.max()
    }
    
    func hasLog(on date: Date) -> Bool {
        loggedDays.contains(calendar.startOfDay(for: date))
    }
    
    func countContinousLoggedDays(endingAt date: Date) -> Int {
        var count = 0
        var currentDay: Date? = calendar.startOfDay(for: date)
        
        while let day = currentDay, hasLog(on: day) {
            count += 1
            currentDay = calendar.date(byAdding: .day, value: -1, to: day)
        }
        return count
    }
    
    func countDaysSince(_ date: Date) -> Int {
        let start = calendar.startOfDay(for: date)
        return calendar.dateComponents([.day], from: start, to: today).day ?? 0
    }
}
