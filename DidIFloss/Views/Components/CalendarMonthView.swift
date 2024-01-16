//
//  CalendarView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 13/01/24.
//

import SwiftUI


struct CalendarMonthView: View {
    
    @Namespace private var selectedDateNameSpace
    @StateObject var viewModel: ViewModel
    
    init(recordDates: [Date]) {
        self._viewModel = StateObject(wrappedValue: ViewModel(records: recordDates))
    }
    
    let gridColums: [GridItem] = Array(repeating:
                                        GridItem(.flexible(minimum: 15, maximum: 50)),
                                       count: 7)
    
    func dayColor(_ date: Date) -> Color {
        if viewModel.isToday(date) {
            return .red
        }
        
        if viewModel.isFromCurrentMonth(date) {
            return .primary
        }
        
        return .secondary
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
                viewModel.previousMonth()
            } label: {
                Image(systemName: "chevron.backward")
            }
            
            Spacer()
            
            Text(viewModel.currentCalendar.dayAndMonthFormatted)
                .font(.headline)
            
            Spacer()
            
            Button {
                viewModel.nextMonth()
            } label: {
                Image(systemName: "chevron.forward")
            }
            .opacity(viewModel.hasNextMonth ? 1 : 0)
            
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func FlossIndicatorView(for date: Date) -> some View {
        let flossCount = viewModel.numberOfFlossRecords(for: date)
        
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
    
    private var calendarGrid: some View {
        LazyVGrid(columns: gridColums, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 15, content: {
            
            ForEach(viewModel.daysOfTheWeek, id: \.self) { day in
                Text(day)
                    .monospaced()
            }
            
            ForEach(viewModel.daysCalendar, id: \.self) { date in
                Text(date.dayFormatted)
                    .foregroundStyle(dayColor(date))
                    .background {
                        if viewModel.isSelectedDate(date) {
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
                        withAnimation {
                            viewModel.dayOfCalendarPressed(date)
                        }
                    }
            }
        })
    }
}

extension CalendarMonthView {
    class ViewModel: ObservableObject {
        
        @Published var currentCalendar: Date = .now
        
        @Published var selecteDate: Date = .now
        
        @Published var records: [Date]
        
        init(currentCalendar: Date = .now, selecteDate: Date = .now, records: [Date]) {
            self.currentCalendar = currentCalendar
            self.selecteDate = selecteDate
            self.records = records
        }
        
        var filterdRecords: [Date] {
            records.filter { date in
                self.isSelectedDate(date)
            }
        }
        
        var calendar: Calendar {
            Calendar.current
        }
        
        var daysOfTheWeek: [String] {
            calendar.shortWeekdaySymbols
        }
        
        var daysCalendar: [Date] {
            return Calendar.getDaysOfTheMonth(for: currentCalendar)
        }
        
        var hasNextMonth: Bool {
            let next = calendar.date(byAdding: .month, value: 1, to: currentCalendar) ?? Date()
            return next <= .now
        }
        
        func nextMonth() {
            if hasNextMonth {
                currentCalendar = calendar.date(byAdding: .month, value: 1, to: currentCalendar) ?? Date()
            }
        }
        
        func previousMonth() {
            currentCalendar = calendar.date(byAdding: .month, value: -1, to: currentCalendar) ?? Date()
        }
        
        func isToday(_ date: Date) -> Bool {
            return calendar.isDateInToday(date)
        }
        
        func isFromCurrentMonth(_ date: Date) -> Bool {
            return calendar.isDate(date, equalTo: Date(), toGranularity: .month)
        }
        
        func addRecordPressed() {
            records.append(selecteDate)
        }
        
        func dayOfCalendarPressed(_ date: Date) {
            selecteDate = date
        }
        
        func isSelectedDate(_ date: Date) -> Bool {
            calendar.isDate(date, equalTo: selecteDate, toGranularity: .day)
        }
        
        func numberOfFlossRecords(for date: Date) -> Int {
            return records
                .filter({calendar.isDate($0, equalTo: date, toGranularity: .day)})
                .count
        }
    }
}


#Preview {
    CalendarMonthView(recordDates: [
        Date(), Date(), Date(),
        Calendar.current.date(byAdding: .day, value: -1, to: .now)!,
        Calendar.current.date(byAdding: .day, value: -1, to: .now)!,
        Calendar.current.date(byAdding: .day, value: -2, to: .now)!
    ])
}
