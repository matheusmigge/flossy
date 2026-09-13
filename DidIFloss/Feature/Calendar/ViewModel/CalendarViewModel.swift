import Foundation
import FlossyCore
import SwiftUI

@MainActor
@Observable
class CalendarViewModel {
    var currentCalendar: Date = .now
    var dateFocused: Date?
    
    func nextCalendarSet(style: CalendarStyle) {
        if hasNextCalendar(style: style) {
            let calendarComponent: Calendar.Component = style == .week ? .weekOfYear : .month
            currentCalendar = Calendar.current.date(byAdding: calendarComponent, value: 1, to: currentCalendar) ?? Date()
        }
    }
    
    func previousCalendarSet(style: CalendarStyle) {
        let calendarComponent: Calendar.Component = style == .week ? .weekOfYear : .month
        currentCalendar = Calendar.current.date(byAdding: calendarComponent, value: -1, to: currentCalendar) ?? Date()
    }
    
    func hasNextCalendar(style: CalendarStyle) -> Bool {
        let dateComponent: Calendar.Component = style == .month ? .month : .weekOfYear
        let next = Calendar.current.date(byAdding: dateComponent, value: 1, to: currentCalendar) ?? Date()
        return next <= .now
    }
    
    func dateLabel(style: CalendarStyle, daysCalendarSet: [Date]) -> String {
        switch style {
        case .month:
            return dateFocused?.monthFormatted ?? currentCalendar.monthFormatted
        case .week:
            let firstDayOfWeek = daysCalendarSet.first?.dayFormatted ?? "XX"
            let lastDayOfWeek = daysCalendarSet.last?.dayFormatted ?? "XX"
            return "\(firstDayOfWeek) - \(lastDayOfWeek) \(currentCalendar.monthFormatted)"
        }
    }
    
    func daysCalendarSet(style: CalendarStyle) -> [Date] {
        switch style {
        case .month:
            return Calendar.getDaysOfTheMonth(for: currentCalendar)
        case .week:
            return Calendar.getDaysOfTheWeek(for: currentCalendar)
        }
    }
    
    func isSelectedDate(_ date: Date) -> Bool {
        guard let safeDateFocused = dateFocused else { return false }
        return Calendar.current.isDate(date, equalTo: safeDateFocused, toGranularity: .day)
    }
    
    func numberOfFlossRecords(for date: Date, recordsDates: [Date]) -> Int {
        return recordsDates
            .filter({ Calendar.current.isDate($0, equalTo: date, toGranularity: .day) })
            .count
    }
    
    func hasDayFlossRecords(for date: Date, recordsDates: [Date]) -> Bool {
        return numberOfFlossRecords(for: date, recordsDates: recordsDates) > 0
    }
    
    func dayColor(_ date: Date) -> Color {
        if Calendar.current.isDateInToday(date) {
            return .red
        }
        
        if Calendar.current.isDate(date, equalTo: currentCalendar, toGranularity: .month) {
            return .primary
        }
        
        return .secondary
    }
    
    func shouldDayOfTheWeekBePink(_ date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: Date())
    }
}
