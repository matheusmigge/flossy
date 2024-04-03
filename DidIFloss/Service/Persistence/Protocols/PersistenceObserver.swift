//
//  PersistanceDelegate.swift
//  DidIFloss
//
//  Created by Lucas Migge on 02/02/24.
//

import Foundation

/// Interface for alerting viewModel of changes in data
protocol PersistanceDelegate: AnyObject {
    func hadChangesInFlossRecordDataBase()
    
}
