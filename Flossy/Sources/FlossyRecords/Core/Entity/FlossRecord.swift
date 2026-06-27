//
//  FlossRecordEntity.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 25/06/26.
//

import Foundation
import SwiftData

@Model
class FlossRecord: Identifiable {
    var id: String
    var date: Date
    var detail: Detail
    
    init(id: String = UUID().uuidString,
         date: Date = .now,
         detail: Detail = Detail.floss) {
        self.id = id
        self.date = date
        self.detail = detail
    }
    
    public enum Detail: Codable, CaseIterable {
        case floss, brush, mouthwash
        
        init(activity: FlossActivity) {
            switch activity {
            case .brush:
                self = .brush
            case .floss:
                self = .floss
            case .mouthwash:
                  self = .mouthwash
            }
        }
    }
    
}

extension FlossRecord {
    convenience init(from model: FlossLog) {
        self.init(
            id: model.id,
            date: model.date,
            detail: Detail(activity: model.activity)
        )
    }
}
