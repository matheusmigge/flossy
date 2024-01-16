//
//  CalendarView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 13/01/24.
//

import SwiftUI

extension Date {
    var monthFornatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yy"
        
        return formatter.string(from: self)
    }
    
    var dayFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        
        return formatter.string(from: self)
    }
    
    var dayAndMonthFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        
        return formatter.string(from: self)
    }
}

extension Calendar {
    
    static func getDaysOfTheMonth(for date: Date) -> [Date] {
        let calendar = Calendar.current
        
        var days = [Date]()
        
        guard let monthInterval = calendar.dateInterval(of: .month, for: date) else { return [] }
        guard let rangeOfDaysInMonth = calendar.range(of: .day, in: .month, for: date) else { return [] }
        
        let firstDayOfMonth = monthInterval.start
        let weekdayOfFirstDay = calendar.component(.weekday, from: firstDayOfMonth)
      

        // Adicione dias do mês anterior para preencher a primeira semana se necessário
        let numberOfDaysFromPreviousMonth = weekdayOfFirstDay - calendar.firstWeekday
        if numberOfDaysFromPreviousMonth > 0 {
            let previousMonthEndDate = calendar.date(byAdding: .day, value: -1, to: firstDayOfMonth)!
            for day in (1 - numberOfDaysFromPreviousMonth)...0 {
                guard let dayDate = calendar.date(byAdding: .day, value: day, to: previousMonthEndDate) else { return [] }
                days.append(dayDate)
            }
        }

        // Adicione dias do mês atual
        rangeOfDaysInMonth.forEach { day in
            guard let dayDate = calendar.date(bySetting: .day, value: day - 1, of: firstDayOfMonth) else { return }
            days.append(dayDate)
        }


        // Adicione dias do mês seguinte para preencher a última semana se necessário
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
    
}

extension CalendarView {
    class ViewModel: ObservableObject {
        
        @Published var currentCalendar: Date = .now
        
        @Published var selecteDate: Date = .now
        
        @Published var records: [Date] = [
            Date(),
            Calendar.current.date(byAdding: .day, value: -1, to: .now)!,
            Calendar.current.date(byAdding: .day, value: -2, to: .now)!
        ]
        
        var calendar: Calendar {
            Calendar.current
        }
        
        var daysOfTheWeek: [String] {
            calendar.shortWeekdaySymbols
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
        
        var daysCalendar: [Date] {
            return Calendar.getDaysOfTheMonth(for: currentCalendar)
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
        
        var filterdRecords: [Date] {
            records.filter { date in
                self.isSelectedDate(date)
            }
            
        }
    }
}

struct CalendarView: View {
    
    @StateObject var viewModel: ViewModel = ViewModel()
    
    let gridColums: [GridItem] = Array(repeating: GridItem(.flexible(minimum: 15, maximum: 50)), count: 7)
    
    func dayColor(_ date: Date) -> Color {
        if viewModel.isSelectedDate(date) {
            return .flamingoPink
        }
        
        if viewModel.isFromCurrentMonth(date) {
            return .primary
        }
        
        return .secondary
    }
    
    var body: some View {
        VStack {
            VStack {
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
            
                LazyVGrid(columns: gridColums, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 15, content: {
                    
                    ForEach(viewModel.daysOfTheWeek, id: \.self) { day in
                        Text(day)
                            .monospaced()
                    }
                    
                    ForEach(viewModel.daysCalendar, id: \.self) { date in
                        Text(date.dayFormatted)
                            .foregroundStyle(dayColor(date))
                            .background {
                                if viewModel.isToday(date) {
                                    Circle()
                                        .fill(Color.skyBlue)
                                        .frame(width: 25, height: 25)
                                }
                            }
                            .onTapGesture {
                                withAnimation {
                                    viewModel.dayOfCalendarPressed(date)
                                }

                            }
                    }
                })
            }
            .padding()
        }
    
        List {
            
            Text(viewModel.selecteDate.dayAndMonthFormatted)
            
            Button {
                viewModel.addRecordPressed()
            } label: {
                Text("Add Record")
            }
            
            ForEach(viewModel.filterdRecords, id: \.self) { date in
                Text(date.formatted())
                
            }
        }
    }
}

#Preview {
    CalendarView()
}
