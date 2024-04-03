//
//  HapticsManagerMock.swift
//  DidIFlossTests
//
//  Created by Lucas Migge on 07/03/24.
//

import Foundation
@testable import DidIFloss

class HapticsManagerMock: HapticsManagerProtocol {
    
    var didCallVibrateCelebration = false
    var didCallVibrateRemoval = false
    
    func vibrateAddLogCelebration() {
        didCallVibrateCelebration = true
    }
    
    func vibrateLogRemoval() {
        didCallVibrateRemoval = true
    }
    
}
