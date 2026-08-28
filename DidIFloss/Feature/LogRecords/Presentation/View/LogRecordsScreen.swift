//
//  LogRecordsView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 26/01/24.
//

import SwiftUI
import FlossyDesignSystem


struct LogRecordsScreen: Screen {
    
    var viewModel: LogRecordsViewModel
    
    var recordsDates: [Date] {
        viewModel.records.map { $0.date }
    }
    
    var body: some View {
        List {
            Section("Calendar") {
                MonthCalendarView(records: recordsDates,
                             delegate: viewModel)
                .padding(.vertical, 7)
            }
            
            Section {
                if viewModel.sectionRecords.isEmpty {
                    noRecordsView
                } else {
                    recordsListView
                }
            } header: {
                Text(sectionLabel)
            } footer: {
                if !viewModel.sectionRecords.isEmpty {
                    Text("You can delete a record by swiping or holding on it")
                }
            }
            
            Section {
                BannerSectionView()
            }
            .listRowInsets(.init(top: -20, leading: -20, bottom: -20, trailing: -20))
        }
        .onAppear {
            viewModel.onAppear()
            viewModel.viewDidApper()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
        .buttonStyle(.borderless)
        .navigationTitle("Records")
    }
    
    private var sectionLabel: String {
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
            contentRow(date: record.date)
                .contextMenu(menuItems: {
                    Button(role: .destructive) {
                        Task { await viewModel.removeRecord(record) }
                    } label: {
                        Text("Delete")
                    }
                })
        }
        .onDelete(perform: { indexSet in
            Task { await viewModel.removeRecordAt(indexSet: indexSet) }
        })
    }
    
    @ViewBuilder
    private func contentRow(date: Date) -> some View {
        HStack(alignment: .center) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.accentColor)
                
                Text(date.dayAndMonthAndYearFormatted)
            }
            
            Spacer()
            
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.accentColor)
                
                Text(date.minuteAndHourFormatted)
            }
        }
    }
}

#Preview {
    NavigationStack {
        LogRecordsScreen(viewModel: LogRecordsViewModel())
    }
}
