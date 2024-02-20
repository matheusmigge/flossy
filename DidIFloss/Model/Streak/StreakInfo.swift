//
//  StreakInfo.swift
//  DidIFloss
//
//  Created by Lucas Migge on 20/02/24.
//

import Foundation


struct StreakInfo {
    enum Streak {
        case positive, positiveMissingToday, negative, empty
    }
    
    let streak: Streak
    let days: Int
}
