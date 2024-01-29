//
//  ContentViewModel.swift
//  DidIFloss
//
//  Created by Matheus Migge on 27/12/23.
//

import Foundation
import SwiftUI
import Notification

class ContentViewModel: ObservableObject {
    
    let persistance: PersistanceManagerProtocol
    
    @Published var selectedDate: Date?
    
    // MARK: Published variables
    
    @Published var records: [FlossRecord] = []
    
    private var lastFlossDate: Date? {
        self.records.last?.date
    }
    
    private var flossCount: Int {
        self.records.count
    }
    
    
    // MARK: Init
    
    init(persistenceService: PersistanceManagerProtocol = PersistanceManager()) {
        self.persistance = persistenceService
        
        self.loadRecords()
    }
    
    
    // MARK: Public variables and methods
    
    var formatedLastFloss: String {
        guard let safeDate = lastFlossDate else {
            return "You haven't flossed yet!"
        }
        
        return dateFormater(safeDate)
    }
    
    func loadRecords() {
        DispatchQueue.main.async { [weak self] in
            self?.persistance.getFlossRecords { result in
                self?.records = result
            }
        }
    }
    
    var formatedFlossCount: String {
        if flossCount == 0 {
            return "You haven't flossed yet!"
        } else {
            return "\(flossCount)"
        }
    }
    
    public func flossButtonPressed() {
        self.saveToPersistance()
        NotificationService.scheduleFlossRemindersNotifications()
        
    }
    
    public func dateFormater(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        return dateFormatter.string(from: date)
    }
    
    // MARK: Private methods
    
    func eraseRecordsButtonPressed() {
        persistance.eraseData()
        
        loadRecords()
    }
    
    private func saveToPersistance() {
        persistance.saveLastFlossDate(date: .now)
        
        loadRecords()
    }
}


// code for LogRecordsView
extension ContentViewModel: CalendarViewDelegate {
    func didSelectDate(_ date: Date) {
        withAnimation {
            selectedDate = selectedDate == date ? nil : date
        }
    }
    
    func removeRecordAt(indexSet: IndexSet) {
        records.remove(atOffsets: indexSet)
        guard let index = indexSet.first else { return }
        persistance.deleteFlossRecord(records[index])
    }
    
    func removeRecord(_ record: FlossRecord) {
        records.removeAll { $0 == record }
        persistance.deleteFlossRecord(record)
    }
    
    var sectionRecords: [FlossRecord] {
        if let date = selectedDate {
            return records.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
        } else {
            return records
        }
    }
}
