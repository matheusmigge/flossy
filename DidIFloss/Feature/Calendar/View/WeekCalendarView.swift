import SwiftUI
import FlossyDesignSystem

struct WeekCalendarView: View {
    @Namespace internal var selectedDateNameSpace
    @State var viewModel = CalendarViewModel()
    var recordsDates: [Date]
    @Environment(\.colorScheme) var colorScheme
    weak var delegate: CalendarViewDelegate?
    
    init(records: [Date], delegate: CalendarViewDelegate? = nil) {
        self.recordsDates = records
        self.delegate = delegate
    }
    
    var body: some View {
        VStack {
            calendarHeader
            weekCalendarGrid
        }
    }
    
    var calendarHeader: some View {
        HStack {
            Button {
                viewModel.previousCalendarSet(style: .week)
            } label: {
                Image(systemName: "chevron.backward")
            }
            
            Spacer()
            
            Text(viewModel.dateLabel(style: .week, daysCalendarSet: viewModel.daysCalendarSet(style: .week)))
                .font(.headline)
            
            Spacer()
            
            Button {
                viewModel.nextCalendarSet(style: .week)
            } label: {
                Image(systemName: "chevron.forward")
            }
            .opacity(viewModel.hasNextCalendar(style: .week) ? 1 : 0)
        }
        .padding(.horizontal)
    }
    
    var weekCalendarGrid: some View {
        HStack(spacing: 5) {
            ForEach(viewModel.daysCalendarSet(style: .week), id: \.self) { day in
                VStack {
                    Text(day.dayOfTheWeek)
                        .monospaced()
                        .font(.callout)
                    
                    Group {
                        if viewModel.hasDayFlossRecords(for: day, recordsDates: recordsDates) {
                            ZStack {
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .foregroundStyle(colorScheme == .light ? Color.white : Color.black)
                                    .frame(width: 30, height: 30)
                                
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .foregroundStyle(Color.accentColor)
                                    .frame(width: 30, height: 30)
                            }
                        } else {
                            Circle()
                                .stroke(lineWidth: 2)
                                .frame(width: 30, height: 30)
                                .foregroundStyle(Calendar.isDateInTheFuture(day) ? Color.gray : Color.primary)
                        }
                    }
                    .onTapGesture {
                        didTapOnDate(day)
                    }
                }
                .padding(5)
                .background {
                    if viewModel.shouldDayOfTheWeekBePink(day) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(FlossyColors.accentColorAlternative)
                    }
                }
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
