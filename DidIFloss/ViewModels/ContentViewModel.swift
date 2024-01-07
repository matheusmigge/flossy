//
//  ContentViewModel.swift
//  DidIFloss
//
//  Created by Matheus Migge on 27/12/23.
//

import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {
    
    let persistance: PersistanceManagerProtocol
    
    // MARK: Published variables
    
    @Published var records: [FlossRecord] = []
    
    private var lastFlossDate: Date? {
        self.records.first?.date
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
        Task {
            self.records = await persistance.getFlossRecords()
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
