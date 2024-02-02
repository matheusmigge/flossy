//
//  HomeViewModel+Enums.swift
//  DidIFloss
//
//  Created by Lucas Migge on 02/02/24.
//

import Foundation

extension HomeViewModel {
    
    enum State {
        case noLogsRecorded, positiveStreak, negativeStreak
    }
    
    enum Sheet: String, Identifiable {
        case welcomeSheet, addLogSheet
        
        var id: String {
            self.rawValue
        }
    }
    
}
