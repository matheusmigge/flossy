//
//  FlossRecord.swift
//  DidIFloss
//
//  Created by Lucas Migge on 04/01/24.
//

import Foundation
import SwiftData

@Model
public class FlossRecord: Identifiable {
    public let id: String
    public let date: Date
    public var detail: Detail
    
    init(id: String = UUID().uuidString,
         date: Date = .now,
         detail: Detail = Detail.floss) {
        self.id = id
        self.date = date
        self.detail = detail
    }
    
    public enum Detail: Codable, CaseIterable {
        case floss, brush, mouthwash

    }
    
}
