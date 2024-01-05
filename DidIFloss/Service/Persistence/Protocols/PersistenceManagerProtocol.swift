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
    
    func saveFlossCount(_ count: Int)
    
    func getFlossCount() -> Int
    
    func getFlossRecords() async -> [FlossRecord]
    
    func appendFlossRecord(_ record: FlossRecord)
    
    func deleteFlossRecord(_ record: FlossRecord)
    
    func eraseData()
}


