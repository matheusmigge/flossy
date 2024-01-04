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
    
}
