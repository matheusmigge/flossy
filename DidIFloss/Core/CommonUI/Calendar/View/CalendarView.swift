//
//  CalendarView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 13/01/24.
//

import SwiftUI
import FlossyDesignSystem

struct CalendarView: View {
    
    @Namespace internal var selectedDateNameSpace
    @State var viewModel = CalendarViewModel()
    
    var recordsDates: [Date]
    @Environment(\.colorScheme) var colorScheme
    
    var style: Style
    weak var delegate: CalendarViewDelegate?
    
    let gridColumns: [GridItem] = Array(repeating:
                                            GridItem(.flexible(minimum: 15, maximum: 50)), count: 7)
    
    init(records: [Date], style: Style, delegate: CalendarViewDelegate? = nil) {
        self.recordsDates = records
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
    
    var calendarHeader: some View {
        HStack {
            Button {
                viewModel.previousCalendarSet(style: style)
            } label: {
                Image(systemName: "chevron.backward")
            }
            
            Spacer()
            
            Text(viewModel.dateLabel(style: style, daysCalendarSet: viewModel.daysCalendarSet(style: style)))
                .font(.headline)
            
            Spacer()
            
            Button {
                viewModel.nextCalendarSet(style: style)
            } label: {
                Image(systemName: "chevron.forward")
            }
            .opacity(viewModel.hasNextCalendar(style: style) ? 1 : 0)
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func FlossIndicatorView(for date: Date) -> some View {
        let flossCount = viewModel.numberOfFlossRecords(for: date, recordsDates: recordsDates)
        
        HStack(spacing: 5) {
            if flossCount > 0 {
                Circle()
                    .foregroundStyle(FlossyColors.flamingoPink)
                    .frame(width: 5)
                    .offset(y: 14)
            }
            if flossCount > 1 {
                Circle()
                    .foregroundStyle(FlossyColors.flamingoPink)
                    .frame(width: 5)
                    .offset(y: 14)
            }
            
            if flossCount > 2 {
                Circle()
                    .foregroundStyle(FlossyColors.flamingoPink)
                    .frame(width: 5)
                    .offset(y: 14)
            }
        }
    }
    
    internal func didTapOnDate(_ date: Date) {
        delegate?.didSelectDate(date)
        withAnimation {
            viewModel.dateFocused = date == viewModel.dateFocused ? nil : date
        }
    }
}

extension CalendarView {
    enum Style {
        case month, week
    }
}


#Preview {
    CalendarView(records: [], style: .month)
}
