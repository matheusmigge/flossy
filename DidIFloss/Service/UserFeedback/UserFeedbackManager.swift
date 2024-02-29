//
//  UserFeedbackManager.swift
//  DidIFloss
//
//  Created by Lucas Migge on 22/02/24.
//

import Foundation
import UIKit


class UserFeedbackManager: ObservableObject, UserFeedbackManagerProtocol {
    
    let generator = UINotificationFeedbackGenerator()
    
    static var shared: UserFeedbackManager = UserFeedbackManager()
    
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
