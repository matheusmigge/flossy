//
//  HapticsManagerProtocol.swift
//  DidIFloss
//
//  Created by Lucas Migge on 22/02/24.
//

import Foundation

/// A protocol that defines the behavior of a haptics manager.
protocol HapticsManagerProtocol: AnyObject {
    
    /// Triggers haptic feedback for a celebration event.
    func vibrateAddLogCelebration()
    
    /// Triggers haptic feedback for a log removal event.
    func vibrateLogRemoval()
}
