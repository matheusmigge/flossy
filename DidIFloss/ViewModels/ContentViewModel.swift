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
    
    @Published private var lastFlossDate: Date?
    @Published private var flossCount: Int
    
    // MARK: Init
    
    @MainActor
    init(persistenceService: PersistanceManagerProtocol = PersistanceManager()) {
        self.persistance = persistenceService
        self.lastFlossDate = persistance.getLastFlossDate()
        self.flossCount = persistance.getFlossCount()
        
        Task {
            self.records = await persistance.getFlossRecords()
        }
        
    }
    
    // MARK: Public variables and methods
    
    var formatedLastFloss: String {
        
        guard let safeDate = lastFlossDate else {
            return "You haven't flossed yet!"
        }
        
        return dateFormtert(safeDate)

    }
    
    var formatedFlossCount: String {
        
        if flossCount == 0 {
            return "You haven't flossed yet!"
        } else {
            return "\(flossCount)"
        }
    }
    
    @MainActor
    func flossButtonPressed() {
        self.updateInfo()
        self.saveToPersistance()
    }
    
    public func dateFormtert(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: date)
    }
    
    // MARK: Private methods
    
    private func updateInfo() {
        self.lastFlossDate = Date()
        self.flossCount += 1
    }
    
    
    @MainActor
    private func saveToPersistance() {
        guard let safeLastFlossDate = lastFlossDate else {
            print("Error: last floss date is null.")
            return
        }
        
        persistance.saveFlossCount(flossCount)
        persistance.saveLastFlossDate(date: safeLastFlossDate)
        
        Task {
            let record = FlossRecord()
            persistance.appendFlossRecord(record)
            self.records = await persistance.getFlossRecords()
            
        }
    }
}
