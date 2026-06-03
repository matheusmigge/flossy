//
//  FlossRecordsRepository.swift
//  DidIFloss
//
//  Created by Lucas Migge on 26/03/24.
//

import Foundation

protocol FlossRecordsRepositoryProtocol: AnyObject {
    
    /// Fetches the floss records and provides them to the specified handler.
    ///
    /// - Parameter handler: A closure that receives an array of FlossRecord.
    func getFlossRecords(handler: @escaping ([FlossRecord]) -> Void)
    
    var delegate: PersistenceDelegate? { get set }
    
}
