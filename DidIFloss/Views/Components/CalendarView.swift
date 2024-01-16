//
//  CalendarView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 13/01/24.
//

import SwiftUI


struct CalendarView: View {
    
    @StateObject var viewModel: ViewModel = ViewModel()
    
    let gridColums: [GridItem] = Array(repeating: GridItem(.flexible(minimum: 15, maximum: 50)), count: 7)
    
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
                                if viewModel.isSelectedDate(date) {
                                    Circle()
                                        .fill(Color.skyBlue)
                                        .frame(width: 30, height: 30)
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

extension CalendarView {
    class ViewModel: ObservableObject {
        
        @Published var currentCalendar: Date = .now
        
        @Published var selecteDate: Date = .now
        
        @Published var records: [Date] = [
            Date(),
            Calendar.current.date(byAdding: .day, value: -1, to: .now)!,
            Calendar.current.date(byAdding: .day, value: -2, to: .now)!
        ]
        
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
        
    }
}


#Preview {
    CalendarView()
}
