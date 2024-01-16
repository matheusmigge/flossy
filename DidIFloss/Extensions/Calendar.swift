//
//  Calendar.swift
//  DidIFloss
//
//  Created by Lucas Migge on 16/01/24.
//

import Foundation

extension Calendar {
    
    static private var calendar: Calendar {
        self.current
    }
    
    static func getDaysOfTheMonth(for date: Date) -> [Date] {
        var days = [Date]()
        
        guard let monthInterval = calendar.dateInterval(of: .month, for: date) else { return [] }
        guard let rangeOfDaysInMonth = calendar.range(of: .day, in: .month, for: date) else { return [] }
        
        let firstDayOfMonth = monthInterval.start
        let weekdayOfFirstDay = calendar.component(.weekday, from: firstDayOfMonth)
        
        // Adds the last days of previuos month if needed to complete first week row
        let numberOfDaysFromPreviousMonth = weekdayOfFirstDay - calendar.firstWeekday
        if numberOfDaysFromPreviousMonth > 0 {
            let previousMonthEndDate = calendar.date(byAdding: .day, value: -1, to: firstDayOfMonth)!
            for day in (1 - numberOfDaysFromPreviousMonth)...0 {
                guard let dayDate = calendar.date(byAdding: .day, value: day, to: previousMonthEndDate) else { return [] }
                days.append(dayDate)
            }
        }
        
        // Adds days of given month
        rangeOfDaysInMonth.forEach { day in
            guard let dayDate = calendar.date(bySetting: .day, value: day - 1, of: firstDayOfMonth) else { return }
            days.append(dayDate)
        }
        
        // Adds first days of next month if needed to complete last week row
        let lastDayOfMonth = monthInterval.end
        let numberOfDaysFromNextMonth = 7 - days.count % 7
        if numberOfDaysFromNextMonth < 7 {
            for day in 1...numberOfDaysFromNextMonth {
                guard let dayDate = calendar.date(byAdding: .day, value: day - 1, to: lastDayOfMonth) else { return [] }
                days.append(dayDate)
            }
        }
        
        return days
    }
    

    
    static func getDaysOfTheWeek(for date: Date) -> [Date] {
    
        var days: [Date] = []
        
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: date) else { return days }
        let firstDayOfTheWeek = weekInterval.start
        
        for index in 0...7 {
            guard let day = calendar.date(byAdding: .day, value: index, to: firstDayOfTheWeek) else { return days }
            days.append(day)
        }
        
        return days
    }
}
