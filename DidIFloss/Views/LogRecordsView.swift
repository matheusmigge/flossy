//
//  LogRecordsView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 26/01/24.
//

import SwiftUI


struct LogRecordsView: View {
    
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        List {

            
            Section("Calendar") {
                CalendarView(records: $viewModel.records,
                             style: .month,
                             delegate: viewModel)
            }
            
            Section {
                if viewModel.sectionRecords.isEmpty {
                    noRecordsView
                } else {
                    recordsListView
                }
            } header: {
                Text(sectionLabel)
            }
            
            Section {
                BannerView()
            }
            .listRowInsets(.init(top: -20, leading: -20, bottom: -20, trailing: -20))

            
        }
        //        .scrollContentBackground(.hidden)
        //        .background(content: {
        //            Color.flossFlamingoPink
        //                .ignoresSafeArea()
        //        })
        .buttonStyle(.borderless)
        .navigationTitle("Records")
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
            Text(record.date.minuteHourDayMonthFormatted)
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
    NavigationStack {
        LogRecordsView(viewModel: ContentViewModel())
    }
}
