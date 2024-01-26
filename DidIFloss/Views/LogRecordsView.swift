//
//  LogRecordsView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 26/01/24.
//

import SwiftUI

extension ContentViewModel: CalendarViewDelegate {
    func didSelectDate(_ date: Date) {
        withAnimation {
            selectedDate = selectedDate == date ? nil : date
        }
    }
    
    func removeRecordAt(indexSet: IndexSet) {
        records.remove(atOffsets: indexSet)
        //        guard let index = indexSet.first else { return }
        //        persistance.deleteFlossRecord(records[index])
    }
    
    func removeRecord(_ record: FlossRecord) {
        records.removeAll { $0 == record }
        //        persistance.deleteFlossRecord(record)
    }
    
    var sectionRecords: [FlossRecord] {
        if let date = selectedDate {
            return records.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
        } else {
            return records
        }
    }
}

struct LogRecordsView: View {
    
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        List {
            Section("Calendar") {
                CalendarView(records: $viewModel.records,
                             style: .month,
                             delegate: viewModel)
            }
            
            Section(sectionLabel) {
                if viewModel.sectionRecords.isEmpty {
                    noRecordsView
                } else {
                    recordsListView
                }
            }
        }
        .buttonStyle(.borderless)
    }
    
    var sectionLabel: String {
        if let date = viewModel.selectedDate {
            return "Records for \(date.dayAndMonthFormatted)"
        } else {
            return "All Records"
        }
    }
    
    private var noRecordsView: some View {
        HStack {
            Spacer()
            
            VStack(alignment: .center, spacing: 10) {
                
                Image(systemName: "tray.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.secondary)
                    .frame(width: 30)
                
                Text("No records")
                    .foregroundStyle(.secondary)
                    .font(.headline)
            }
            
            Spacer()
        }
        .frame(height: 100)
    }
    
    private var recordsListView: some View {
        ForEach(viewModel.sectionRecords) { record in
            Text(record.date.dayAndMonthFormatted)
                .contextMenu(menuItems: {
                    Button(role: .destructive) {
                        viewModel.removeRecord(record)
                    } label: {
                        Text("Delete")
                    }
                })
            
        }
        .onDelete(perform: { indexSet in
            viewModel.removeRecordAt(indexSet: indexSet)
        })
    }
}

#Preview {
    LogRecordsView(viewModel: ContentViewModel())
}
