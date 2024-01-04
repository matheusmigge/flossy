//
//  ContentViewModel.swift
//  DidIFloss
//
//  Created by Matheus Migge on 27/12/23.
//

import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {
    
    
    let persistance: PersistanceManager = PersistanceManager()
    let recordService: FlossRecordDataSouce = FlossRecordDataSouce.shared
    
    // MARK: Published variables

    @Published var records: [FlossRecord]
    
    @Published private var lastFlossDate: Date?
    @Published private var flossCount: Int
    
    // MARK: Init
    
    init() {
        
        self.lastFlossDate = persistance.getLastFlossDate()
        self.flossCount = persistance.getFlossCount()
        self.records = recordService.fetchItems()
        
    }
    
    // MARK: Public variables and methods
    
    var formatedLastFloss: String {
        
        guard let safeDate = lastFlossDate else {
            return "You haven't flossed yet!"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: safeDate)
        
        //        if let safeDate = lastFloss {
        //            let dateFormatter = DateFormatter()
        //            dateFormatter.dateStyle = .medium
        //            dateFormatter.timeStyle = .short
        //
        //            return dateFormatter.string(from: safeDate)
        //        }
        //
        //        return "You haven't flossed yet!"
    }
    
    var formatedFlossCount: String {
        
        if flossCount == 0 {
            return "You haven't flossed yet!"
        } else {
            return "\(flossCount)"
        }
    }
    
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
        self.recordService.appendItem(item: FlossRecord(date: .now))
        self.records = recordService.fetchItems()
        self.lastFlossDate = Date()
        self.flossCount += 1
    }
    
    private func saveToPersistance() {
        guard let safeLastFlossDate = lastFlossDate else {
            print("Error: last floss date is null.")
            return
        }
        
        persistance.saveFlossCount(flossCount)
        persistance.saveLastFlossDate(date: safeLastFlossDate)
    }
}
