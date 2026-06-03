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
    
    enum Sheet: Identifiable {
        
        case welcomeSheet
        case addLogSheet
        case shareStreak(streakInfo: String)
        case developerSheet
        
        var id: String {
            switch self {
            case .welcomeSheet:
                return "welcome"
            case .addLogSheet:
                return "addLog"
            case .shareStreak:
                return "shareStreak"
            case .developerSheet:
                return "developer"
            }
        }
    }
    
}
