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
    @Published private var flossCount: Int = 0
    
    
    // MARK: Init
    
    @MainActor
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
    
    @MainActor
    func loadRecords() {
        self.lastFlossDate = persistance.getLastFlossDate()
        self.flossCount = persistance.getFlossCount()
        
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
    
    @MainActor
    func flossButtonPressed() {
        self.updateInfo()
        self.saveToPersistance()
    }
    
    public func dateFormater(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        return dateFormatter.string(from: date)
    }
    
    // MARK: Private methods
    
    private func updateInfo() {
        self.lastFlossDate = Date()
        self.flossCount += 1
    }
    
    @MainActor
    func eraseRecordsButtonPressed() {
        persistance.eraseData()
        loadRecords()
    }
    
    
    @MainActor
    private func saveToPersistance() {
        guard let safeLastFlossDate = lastFlossDate else {
            print("Error: last floss date is null.")
            return
        }
        
        persistance.saveFlossCount(flossCount)
        persistance.saveLastFlossDate(date: safeLastFlossDate)
        
        loadRecords()
    }
}
