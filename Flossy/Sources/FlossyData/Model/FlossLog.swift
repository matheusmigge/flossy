//
//  FlossLog.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 25/06/26.
//

import Foundation

public struct FlossLog: Identifiable, Equatable, Sendable {
    public let id: String
    public let date: Date
    public let activity: FlossActivity
    
    public init(flossDate date: Date) {
        self.id = UUID().uuidString
        self.date = date
        self.activity = .floss
    }
    
    init(id: String, date: Date, activity: FlossActivity) {
        self.id = id
        self.date = date
        self.activity = activity
    }
    
    init?(from model: FlossRecord) {
        self.id = model.id
        self.date = model.date
        self.activity = FlossActivity(from: model.detail)
    }
}
