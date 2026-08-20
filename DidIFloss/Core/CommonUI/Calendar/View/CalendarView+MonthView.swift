//
//  CalendarView+MonthView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 05/02/24.
//

import Foundation
import SwiftUI
import FlossyDesignSystem

extension CalendarView {
    
    var monthCalendarGrid: some View {
        LazyVGrid(columns: self.gridColumns, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 15, content: {
            
            daysOfTheWeekMonthView
            
            dayMonthCalendarGridView
            
        })
    }
    
    var daysOfTheWeekMonthView: some View {
        ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { day in
            Text(day)
                .foregroundStyle(.secondary)
                .monospaced()
        }
    }
    
    var dayMonthCalendarGridView: some View {
        ForEach(viewModel.daysCalendarSet(style: .month), id: \.self) { date in
            Text(date.dayFormatted)
                .foregroundStyle(viewModel.dayColor(date))
                .background {
                    if viewModel.isSelectedDate(date) {
                        Circle()
                            .fill(FlossyColors.accentColorAlternative)
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

