//
//  UserDefaultsMock.swift
//  DidIFlossTests
//
//  Created by Lucas Migge on 05/02/24.
//

import Foundation
@testable import DidIFloss

final class UserDefaultsMock: UserDefaultable {
    
    var didCallSet: Bool = false
    var didUserAlreadyUseApp: Bool = false
    var lastFlossDate: Date? = .distantPast
    
    func set(_ value: Any?, forKey: String) {
        didCallSet = true
        if let date = value as? Date {
            lastFlossDate = date
        }
    }
    
    func integer(forKey: String) -> Int {
        return Int.random(in: Int.min...Int.max)
    }
    
    func value(forKey: String) -> Any? {
        let lastFlossDateKey = PersistenceManager.UserDefaultsKeys.date
        
        if forKey == lastFlossDateKey {
            return lastFlossDate
        }
        
        return "nil"
    }
    
    func bool(forKey: String) -> Bool {
        let previousUserKey = PersistenceManager.UserDefaultsKeys.didUserAlreadyUseApp
        
        if forKey == previousUserKey {
            return didUserAlreadyUseApp
        } else {
            return Bool.random()
        }
    }
}
