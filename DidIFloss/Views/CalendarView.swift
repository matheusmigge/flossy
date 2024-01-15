//
//  CalendarView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 13/01/24.
//

import SwiftUI

extension Date {
    var month: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yy"
        
        return formatter.string(from: self)
    }
    
    var day: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        
        return formatter.string(from: self)
    }
    
}

extension CalendarView {
    class ViewModel: ObservableObject {
        
        var calendar: Calendar {
            Calendar.current
        }
        
        let daysOfTheWeek = Calendar.current.shortWeekdaySymbols
        let today = Date()
    
        @Published var currentCalendar: Date = Date()
        
        var hasNextMonth: Bool {
            let next = calendar.date(byAdding: .month, value: 1, to: currentCalendar) ?? Date()
            return next <= today
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
        
        func getDaysOfTheMonth(for date: Date) -> [Date] {
            
            guard let month = calendar.dateInterval(of: .month, for: date) else { return [] }
            
            guard let range = calendar.range(of: .day, in: .month, for: date) else { return [] }
            
            var days = [Date]()
            
            range.forEach { int in
                guard let day = calendar.date(byAdding: .day, value: int - 1, to: month.start) else { return }
                days.append(day)
            }
            return days
        }
    
        
        
        func getDaysOfTheMonthh(for date: Date) -> [Date] {
            guard let monthInterval = calendar.dateInterval(of: .month, for: date) else { return [] }

            let firstDayOfMonth = monthInterval.start
            let weekdayOfFirstDay = calendar.component(.weekday, from: firstDayOfMonth)
            let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: date)?.count ?? 0

            var days = [Date]()

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
            for day in 1...numberOfDaysInMonth {
                guard let dayDate = calendar.date(bySetting: .day, value: day, of: firstDayOfMonth) else { return [] }
                days.append(dayDate)
            }

            // Adicione dias do mês seguinte para preencher a última semana se necessário
            let lastDayOfMonth = monthInterval.end
            let numberOfDaysFromNextMonth = 7 - days.count % 7
            if numberOfDaysFromNextMonth > 0 {
                for day in 1...numberOfDaysFromNextMonth {
                    guard let dayDate = calendar.date(byAdding: .day, value: day, to: lastDayOfMonth) else { return [] }
                    days.append(dayDate)
                }
            }

            return days
        }
        
        func isFromCurrentMonth(_ date: Date) -> Bool {
            return date.month == today.month
        }

    }
}

struct CalendarView: View {
    
    @StateObject var viewModel: ViewModel = ViewModel()
    
    let gridColums: [GridItem] = Array(repeating: GridItem(.flexible(minimum: 20, maximum: 50)), count: 7)
    
    func dayColor(_ date: Date) -> Color {
        if viewModel.isToday(date) {
            return .blue
        }
        
        if viewModel.isFromCurrentMonth(date) {
            return .primary
        }
        
        return .secondary
        
    }
    
    var body: some View {
        VStack {

            HStack {
                Button {
                    viewModel.previousMonth()
                } label: {
                    Image(systemName: "chevron.backward")
                }
                
                Spacer()
                
                
                Text(viewModel.currentCalendar.month)
                
                Spacer()
                
                Button {
                    viewModel.nextMonth()
                } label: {
                    Image(systemName: "chevron.forward")
                }
                .opacity(viewModel.hasNextMonth ? 1 : 0)
                
            }
        
            LazyVGrid(columns: gridColums, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5, content: {
                
                ForEach(viewModel.daysOfTheWeek, id: \.self) { day in
                        Text(day)
                }
                
                ForEach(viewModel.getDaysOfTheMonthh(for: viewModel.currentCalendar), id: \.self) { date in
                    Text(date.day)
                        .foregroundStyle(dayColor(date))
                }
            })

        }
        .padding()
        
    }
}

#Preview {
    CalendarView()
}
