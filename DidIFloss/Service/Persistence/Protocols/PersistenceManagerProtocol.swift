//
//  PersistenceManagerProtocol.swift
//  DidIFloss
//
//  Created by Lucas Migge on 04/01/24.
//

import Foundation

protocol PersistanceManagerProtocol {
    func saveLastFlossDate(date: Date)
    
    func getLastFlossDate() -> Date?
    
    func getFlossRecords() async -> [FlossRecord]
    
    func deleteFlossRecord(_ record: FlossRecord)
    
    func eraseData()
}


