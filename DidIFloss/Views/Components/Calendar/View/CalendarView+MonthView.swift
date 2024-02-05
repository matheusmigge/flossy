//
//  CalendarView+MonthView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 05/02/24.
//

import Foundation
import SwiftUI

extension CalendarView {
    
    var monthCalendarGrid: some View {
        LazyVGrid(columns: self.gridColumns, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 15, content: {
            
            daysOfTheWeekMonthView
            
            dayMonthCalendarGridView
            
        })
    }
    
    var daysOfTheWeekMonthView: some View {
        ForEach(self.daysOfTheWeek, id: \.self) { day in
            Text(day)
                .foregroundStyle(.secondary)
                .monospaced()
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

