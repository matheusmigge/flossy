//
//  FlossRecord+Sample.swift
//  DidIFloss
//
//  Created by Lucas Migge on 05/02/24.
//

import Foundation

extension FlossRecord {
    static var sampleData: [FlossRecord] { [
        FlossRecord(date: Calendar.createDate(year: 2024, month: 1, day: 29, hour: 6, minute: 00) ?? Date()),
        FlossRecord(date: Calendar.createDate(year: 2024, month: 1, day: 30, hour: 6, minute: 00) ?? Date()) ,
        FlossRecord(date: Calendar.createDate(year: 2024, month: 1, day: 31, hour: 6, minute: 00) ?? Date()),
        FlossRecord(date: .now)
    ]
        
    }
}
