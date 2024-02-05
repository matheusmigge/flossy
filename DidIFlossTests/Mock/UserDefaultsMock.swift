//
//  UserDefaultsMock.swift
//  DidIFlossTests
//
//  Created by Lucas Migge on 05/02/24.
//

import Foundation
import DidIFloss

final class UserDefaultsMock: UserDefaultable {
    var didCallSet: Bool = false
    
    func set(_ value: Any?, forKey: String) {
        didCallSet = true
    }
    
    func integer(forKey: String) -> Int {
        return Int.random(in: Int.min...Int.max)
    }
    
    func value(forKey: String) -> Any? {
        return nil
    }
    
    func bool(forKey: String) -> Bool {
        return Bool.random()
    }
    
    
}
