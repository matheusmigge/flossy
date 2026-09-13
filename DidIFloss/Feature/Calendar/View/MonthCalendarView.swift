import SwiftUI
import FlossyCore
import FlossyDesignSystem

struct MonthCalendarView: View {
    @Namespace internal var selectedDateNameSpace
    @State var viewModel = CalendarViewModel()
    var recordsDates: [Date]
    @Environment(\.colorScheme) var colorScheme
    weak var delegate: CalendarViewDelegate?
    
    let gridColumns: [GridItem] = Array(repeating: GridItem(.flexible(minimum: 15, maximum: 50)), count: 7)
    
    init(records: [Date], delegate: CalendarViewDelegate? = nil) {
        self.recordsDates = records
        self.delegate = delegate
    }
    
    var body: some View {
        VStack {
            calendarHeader
            monthCalendarGrid
                .padding(.top, 5)
        }
    }
    
    var calendarHeader: some View {
        HStack {
            Button {
                viewModel.previousCalendarSet(style: .month)
            } label: {
                Image(systemName: "chevron.backward")
            }
            
            Spacer()
            
            Text(viewModel.dateLabel(style: .month, daysCalendarSet: viewModel.daysCalendarSet(style: .month)))
                .font(.headline)
            
            Spacer()
            
            Button {
                viewModel.nextCalendarSet(style: .month)
            } label: {
                Image(systemName: "chevron.forward")
            }
            .opacity(viewModel.hasNextCalendar(style: .month) ? 1 : 0)
        }
        .padding(.horizontal)
    }
    
    var monthCalendarGrid: some View {
        LazyVGrid(columns: self.gridColumns, alignment: .center, spacing: 15) {
            ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { day in
                Text(day)
                    .foregroundStyle(.secondary)
                    .monospaced()
            }
            
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
    
    @ViewBuilder
    func FlossIndicatorView(for date: Date) -> some View {
        let flossCount = viewModel.numberOfFlossRecords(for: date, recordsDates: recordsDates)
        
        HStack(spacing: 5) {
            if flossCount > 0 {
                Circle().foregroundStyle(FlossyColors.flamingoPink).frame(width: 5).offset(y: 14)
            }
            if flossCount > 1 {
                Circle().foregroundStyle(FlossyColors.flamingoPink).frame(width: 5).offset(y: 14)
            }
            if flossCount > 2 {
                Circle().foregroundStyle(FlossyColors.flamingoPink).frame(width: 5).offset(y: 14)
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
