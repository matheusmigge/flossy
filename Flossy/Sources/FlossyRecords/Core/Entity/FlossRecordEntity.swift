//
//  FlossRecordEntity.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 25/06/26.
//

import Foundation
import SwiftData

@Model
final class FlossRecordEntity {
    var id: String
    var date: Date
    var activity: String
    
    init(id: String, date: Date, activity: String) {
        self.id = id
        self.date = date
        self.activity = activity
    }
}

extension FlossRecordEntity {
    convenience init(from model: FlossLog) {
        self.init(
            id: model.id,
            date: model.date,
            activity: model.activity.rawValue
        )
    }
}
