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
    
    @State var selecteDate: Date = .now
    
    @Binding var records: [FlossRecord]
    
    var style: Style
    
    weak var delegate: CalendarViewDelegate?
    
    let gridColums: [GridItem] = Array(repeating:
                                        GridItem(.flexible(minimum: 15, maximum: 50)), count: 7)
    
    init(records: Binding<[FlossRecord]>, style: Style, delegate: CalendarViewDelegate? = nil) {
        self._records = records
        self.style = style
        self.delegate = delegate
    }
    
    var body: some View {
        VStack {
            calendarHeader
            
            calendarGrid
            
        }
        .padding()
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
            .opacity(self.hasNexCalendar ? 1 : 0)
            
        }
        .padding(.horizontal)
    }
    
    private var calendarGrid: some View {
        LazyVGrid(columns: self.gridColums, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 15, content: {
            
            ForEach(self.daysOfTheWeek, id: \.self) { day in
                Text(day)
                    .monospaced()
            }
            
            switch style {
            case .month:
                dayMonthCalendarGridView
            case .week:
                dayWeekCalenderGridView
                
            }
        })
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
                    delegate?.didSelectDate(date)
                    withAnimation {
                        self.dayOfCalendarPressed(date)
                    }
                }
        }
    }
    
    var dayWeekCalenderGridView: some View {
        ForEach(self.daysCalendarSet, id: \.self) { date in
            Group {
                if self.hasDayFlossRecords(for: date) {
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
                delegate?.didSelectDate(date)
                withAnimation {
                    self.dayOfCalendarPressed(date)
                }
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
    
    var filterdRecords: [Date] {
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
            return selecteDate.dayAndMonthFormatted
        case .week:
            let firstDayOfWeek = daysCalendarSet.first?.dayFormatted ?? "XX"
            let lastDayOfWeek = daysCalendarSet.last?.dayFormatted ?? "XX"
            
            return "\(firstDayOfWeek) - \(lastDayOfWeek) \(currentCalendar.monthFornatted)"
        }
    }
    
    var hasNexCalendar: Bool {
        let dateComponent: Calendar.Component = style == .month ? .month : .weekOfYear
        
        let next = calendar.date(byAdding: dateComponent, value: 1, to: currentCalendar) ?? Date()
        return next <= .now
    }
    
    func nextCalendarSet() {
        if hasNexCalendar {
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
        return calendar.isDate(date, equalTo: Date(), toGranularity: .month)
    }
    
    func dayOfCalendarPressed(_ date: Date) {
        selecteDate = date
    }
    
    func isSelectedDate(_ date: Date) -> Bool {
        calendar.isDate(date, equalTo: selecteDate, toGranularity: .day)
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
}


#Preview {
    CalendarView(records: .constant([]), style: .month)
}
