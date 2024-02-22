//
//  UserFeedbackManager.swift
//  DidIFloss
//
//  Created by Lucas Migge on 22/02/24.
//

import Foundation
import UIKit

protocol UserFeedbackManagerProtocol {
    func vibrateCelebration()
    func vibrateDeletion()
    
}

enum FeedbackOption: Hashable {
    case success
    case warning
    case error
    case none
}


class UserFeedbackManager: ObservableObject, UserFeedbackManagerProtocol {
    
    enum VibrationStyle {
        case celebration, deletion
    }
    
    var generator = UINotificationFeedbackGenerator()
    
    static var shared: UserFeedbackManager = UserFeedbackManager()
    
    @Published var preferredCelebrationFeedbackType: FeedbackOption = .none
    @Published var preferredDeletionFeedbackType: FeedbackOption = .none
    
    func vibrateDevice(for type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
        
    }

    func vibrateCelebration() {
    
        switch self.preferredCelebrationFeedbackType {
        case .success:
            vibrateDevice(for: .success)
        case .warning:
            vibrateDevice(for: .warning)
        case .error:
            vibrateDevice(for: .error)
        case .none:
            return
        }
    }
    
    func vibrateDeletion() {
        switch self.preferredDeletionFeedbackType {
        case .success:
            vibrateDevice(for: .success)
        case .warning:
            vibrateDevice(for: .warning)
        case .error:
            vibrateDevice(for: .error)
        case .none:
            return
        }
    }
    
}
