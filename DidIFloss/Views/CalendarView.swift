//
//  CalendarView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 13/01/24.
//

import SwiftUI

extension CalendarView {
    class ViewModel: ObservableObject {
        
        var calendar: Calendar {
            Calendar.current
        }
        
        let daysOfTheWeek = Calendar.current.shortWeekdaySymbols
        let today = Date.now
        
        func isToday(_ date: Date) -> Bool {
            return calendar.isDateInToday(date)
        }
        
        func getDaysOfTheMonth() -> [Date] {
            
            guard let month = calendar.dateInterval(of: .month, for: today) else { return [] }
            
            guard let range = calendar.range(of: .day, in: .month, for: today) else { return [] }
            
            var days = [Date]()
            
            range.forEach { int in
                guard let day = calendar.date(byAdding: .day, value: int - 1, to: month.start) else { return }
                days.append(day)
            }
            return days
        }
    
    }
}

struct CalendarView: View {
    
    @StateObject var viewModel: ViewModel = ViewModel()
    
    let gridColums: [GridItem] = Array(repeating: GridItem(.flexible(minimum: 20, maximum: 50), spacing: 10, alignment: .center), count: 7)
    
    var body: some View {
        VStack {
            
        
            LazyVGrid(columns: gridColums, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5, content: {
                
                ForEach(viewModel.daysOfTheWeek, id: \.self) { day in
                        Text(day)
                }
                
                ForEach(viewModel.getDaysOfTheMonth(), id: \.self) { date in
                    Text(date.formatted(date: .numeric, time: .omitted))
                        .foregroundStyle(viewModel.isToday(date) ? Color.blue : Color.red)
                }
            })

        }
    }
}

#Preview {
    CalendarView()
}
