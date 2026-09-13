//
//  UserDefaultsMock.swift
//  DidIFlossTests
//
//  Created by Lucas Migge on 05/02/24.
//

import Foundation
import FlossyCore
@testable import DidIFloss

final class UserDefaultsMock: UserDefaultable {
    
    var didCallSet: Bool = false
    var didUserAlreadyUseApp: Bool = false
    
    func set(_ value: Any?, forKey: String) {
        didCallSet = true
        
        let previousUserKey = AppPreferences.UserDefaultsKeys.didUserAlreadyUseApp
        if forKey == previousUserKey {
            guard let safeValue = value as? Bool else { return }
            didUserAlreadyUseApp = safeValue
        }
    }
    
    func integer(forKey: String) -> Int {
        return Int.random(in: Int.min...Int.max)
    }
    
    func value(forKey: String) -> Any? {
        return nil
    }
    
    func bool(forKey: String) -> Bool {
        let previousUserKey = AppPreferences.UserDefaultsKeys.didUserAlreadyUseApp
        
        if forKey == previousUserKey {
            return didUserAlreadyUseApp
        } else {
            return Bool.random()
        }
    }
}
