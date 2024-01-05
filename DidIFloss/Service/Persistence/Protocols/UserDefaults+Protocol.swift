//
//  UserDefaults+Protocol.swift
//  DidIFloss
//
//  Created by Lucas Migge on 04/01/24.
//

import Foundation

extension UserDefaults: UserDefaultsProtocol {}

protocol UserDefaultsProtocol {
    func set(_ value: Any?, forKey: String)
    
    func integer(forKey: String) -> Int
    
    func value(forKey: String) -> Any?
    
    
}
