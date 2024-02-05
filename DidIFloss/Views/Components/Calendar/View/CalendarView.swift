//
//  CalendarView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 13/01/24.
//

import SwiftUI


struct CalendarView: View {
    
    @Namespace private var selectedDateNameSpace
    
    @State var currentCalendar: Date = .now
    
    @State var dateFocused: Date?
    
    @Binding var records: [FlossRecord]
    
    var style: Style
    
    weak var delegate: CalendarViewDelegate?
    
    let gridColumns: [GridItem] = Array(repeating:
                                        GridItem(.flexible(minimum: 15, maximum: 50)), count: 7)
    
    init(records: Binding<[FlossRecord]>, style: Style, delegate: CalendarViewDelegate? = nil) {
        self._records = records
        self.style = style
        self.delegate = delegate
    }
    
    var body: some View {
        VStack {
            calendarHeader
            
            switch style {
            case .month:
                monthCalendarGrid
                    .padding(.top, 5)
            case .week:
                weekCalendarGrid
            }
        }
        
    }
    
    
    private var calendarHeader: some View {
        HStack {
            Button {
                self.previousCalendarSet()
            } label: {
                Image(systemName: "chevron.backward")
            }
            
            Spacer()
            
            Text(self.dateLabel)
                .font(.headline)
            
            Spacer()
            
            Button {
                self.nextCalendarSet()
            } label: {
                Image(systemName: "chevron.forward")
            }
            .opacity(self.hasNextCalendar ? 1 : 0)
            
        }
        .padding(.horizontal)
    }
    
    private var monthCalendarGrid: some View {
        LazyVGrid(columns: self.gridColumns, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 15, content: {
            
            daysOfTheWeekMonthView
            
            dayMonthCalendarGridView
            
        })
    }
    
    private var daysOfTheWeekMonthView: some View {
        ForEach(self.daysOfTheWeek, id: \.self) { day in
            Text(day)
                .foregroundStyle(.secondary)
                .monospaced()
        }
    }
    
    private var weekCalendarGrid: some View {
        HStack(spacing: 5) {
            ForEach(self.daysCalendarSet, id: \.self) { day in
                VStack {
                    Text(day.dayOfTheWeek)
                        .monospaced()
                        .font(.callout)
                    
                    Group {
                        if self.hasDayFlossRecords(for: day) {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .foregroundStyle(.greenyBlue)
                                .frame(width: 30, height: 30)
                        } else {
                            Circle()
                                .stroke(lineWidth: 2)
                                .frame(width: 30, height: 30)
                        }
                    }
                    .onTapGesture {
                        didTapOnDate(day)
                    }
                }
                .padding(5)
                .background {
                    if shouldDayOfTheWeekBePink(day) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.flossFlamingoPink)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func FlossIndicatorView(for date: Date) -> some View {
        let flossCount = self.numberOfFlossRecords(for: date)
        
        HStack(spacing: 5) {
            if flossCount > 0 {
                Circle()
                    .foregroundStyle(Color.flossFlamingoPink)
                    .frame(width: 5)
                    .offset(y: 14)
            }
            if flossCount > 1 {
                Circle()
                    .foregroundStyle(Color.flossFlamingoPink)
                    .frame(width: 5)
                    .offset(y: 14)
            }
            
            if flossCount > 2 {
                Circle()
                    .foregroundStyle(Color.flossFlamingoPink)
                    .frame(width: 5)
                    .offset(y: 14)
            }
        }
    }
    
    var dayMonthCalendarGridView: some View {
        ForEach(self.daysCalendarSet, id: \.self) { date in
            Text(date.dayFormatted)
                .foregroundStyle(dayColor(date))
                .background {
                    if self.isSelectedDate(date) {
                        Circle()
                            .fill(Color.skyBlue)
                            .frame(width: 30, height: 30)
                            .matchedGeometryEffect(id: "selectedDateNameSpace", in: selectedDateNameSpace)
                    }
                }
                .overlay {
                    FlossIndicatorView(for: date)
                }
                .onTapGesture {
                    didTapOnDate(date)
                }
        }
    }
}

extension CalendarView {
    enum Style {
        case month, week
    }
}

extension CalendarView {
    
    var filteredRecords: [Date] {
        records.filter { record in
            self.isSelectedDate(record.date)
        }.map { record in
            record.date
        }
    }
    
    var calendar: Calendar {
        Calendar.current
    }
    
    var daysOfTheWeek: [String] {
        calendar.shortWeekdaySymbols
    }
    
    var daysCalendarSet: [Date] {
        switch style {
        case .month:
            return Calendar.getDaysOfTheMonth(for: currentCalendar)
        case .week:
            return Calendar.getDaysOfTheWeek(for: currentCalendar)
        }
    }
    
    var dateLabel: String {
        switch style {
        case .month:
            return dateFocused?.monthFormatted ?? currentCalendar.monthFormatted
        case .week:
            let firstDayOfWeek = daysCalendarSet.first?.dayFormatted ?? "XX"
            let lastDayOfWeek = daysCalendarSet.last?.dayFormatted ?? "XX"
            
            return "\(firstDayOfWeek) - \(lastDayOfWeek) \(currentCalendar.monthFormatted)"
        }
    }
    
    var hasNextCalendar: Bool {
        let dateComponent: Calendar.Component = style == .month ? .month : .weekOfYear
        
        let next = calendar.date(byAdding: dateComponent, value: 1, to: currentCalendar) ?? Date()
        return next <= .now
    }
    
    func nextCalendarSet() {
        if hasNextCalendar {
            let calendarComponent: Calendar.Component = style == .week ? .weekOfYear : .month
            
            currentCalendar = calendar.date(byAdding: calendarComponent, value: 1, to: currentCalendar) ?? Date()
        }
    }
    
    func previousCalendarSet() {
        let calendarComponent: Calendar.Component = style == .week ? .weekOfYear : .month
        
        currentCalendar = calendar.date(byAdding: calendarComponent, value: -1, to: currentCalendar) ?? Date()
    }
    
    func isToday(_ date: Date) -> Bool {
        return calendar.isDateInToday(date)
    }
    
    func isFromCurrentCalendarSet(_ date: Date) -> Bool {
        return calendar.isDate(date, equalTo: currentCalendar, toGranularity: .month)
    }
    
    func isSelectedDate(_ date: Date) -> Bool {
        guard let safeDateFocused = dateFocused else { return false}
        return calendar.isDate(date, equalTo: safeDateFocused, toGranularity: .day)
    }
    
    func numberOfFlossRecords(for date: Date) -> Int {
        return records
            .filter({calendar.isDate($0.date, equalTo: date, toGranularity: .day)})
            .count
    }
    
    func hasDayFlossRecords(for date: Date) -> Bool {
        let recordsCount = records
            .filter({calendar.isDate($0.date, equalTo: date, toGranularity: .day)})
            .count
        return recordsCount > 0
    }
    
    func dayColor(_ date: Date) -> Color {
        if isToday(date) {
            return .red
        }
        
        if isFromCurrentCalendarSet(date) {
            return .primary
        }
        
        return .secondary
    }
    
    private func didTapOnDate(_ date: Date) {
        guard let safeDelegate = delegate else { return }
        
        safeDelegate.didSelectDate(date)
        withAnimation {
            dateFocused = date == dateFocused ? nil : date
        }
    }
    
    private func shouldDayOfTheWeekBePink(_ date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: Date())
    }
}


#Preview {
    CalendarView(records: .constant([]), style: .month)
}
