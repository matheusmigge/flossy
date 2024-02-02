//
//  FlossRecord.swift
//  DidIFloss
//
//  Created by Lucas Migge on 04/01/24.
//

import Foundation
import SwiftData

@Model
class FlossRecord: Identifiable {
    var id: String
    var date: Date
    
    init(id: String = UUID().uuidString, date: Date = .now) {
        self.id = id
        self.date = date
    }
    
    static var sampleData: [FlossRecord] { [
        FlossRecord(date: Calendar.createDate(year: 2024, month: 1, day: 29, hour: 6, minute: 00)),
        FlossRecord(date: Calendar.createDate(year: 2024, month: 1, day: 30, hour: 6, minute: 00)),
        FlossRecord(date: Calendar.createDate(year: 2024, month: 1, day: 31, hour: 6, minute: 00)),
        FlossRecord(date: .now)
    ]
        
    }
    
}
