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
    
    @Published var preferredCelebrationFeedbackType: HapticFeedbackOption = .none
    @Published var preferredDeletionFeedbackType: HapticFeedbackOption = .none
    
    func vibrateDevice(for type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
        
    }

    func vibrateCelebration() {
        guard let feedbackType = preferredCelebrationFeedbackType.feedBackStyle else { return }
        vibrateDevice(for: feedbackType)

    }
    
    func vibrateDeletion() {
        guard let feedbackType = preferredDeletionFeedbackType.feedBackStyle else { return }
        vibrateDevice(for: feedbackType)
    }
    
}
