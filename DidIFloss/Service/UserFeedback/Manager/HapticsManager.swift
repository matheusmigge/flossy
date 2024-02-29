//
//  HapticsManager.swift
//  DidIFloss
//
//  Created by Lucas Migge on 22/02/24.
//

import Foundation
import UIKit


class HapticsManager: ObservableObject, HapticsManagerProtocol {
    
    let generator: UINotificationFeedbackGeneratable
    
    static var shared: HapticsManager = HapticsManager()
    
    init(feedbackGenerator: UINotificationFeedbackGeneratable = UINotificationFeedbackGenerator()) {
        self.generator = feedbackGenerator
    }
    
    @Published var preferredCelebrationFeedbackType: HapticFeedbackOption = .long
    @Published var preferredDeletionFeedbackType: HapticFeedbackOption = .short
    
    func vibrateDevice(for type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
        
    }

    func vibrateAddLogCelebration() {
        guard let feedbackType = preferredCelebrationFeedbackType.feedBackStyle else { return }
        vibrateDevice(for: feedbackType)

    }
    
    func vibrateLogRemoval() {
        guard let feedbackType = preferredDeletionFeedbackType.feedBackStyle else { return }
        vibrateDevice(for: feedbackType)
    }
    
}

