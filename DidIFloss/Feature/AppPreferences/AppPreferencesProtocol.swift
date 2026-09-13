//
//  PersistenceManagerProtocol.swift
//  DidIFloss
//
//  Created by Lucas Migge on 04/01/24.
//

import Foundation


protocol AppPreferencesProtocol: AnyObject {
    func checkIfIsNewUser() -> Bool

}
