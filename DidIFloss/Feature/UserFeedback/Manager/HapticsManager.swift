//
//  HapticsManager.swift
//  DidIFloss
//
//  Created by Lucas Migge on 22/02/24.
//

import Foundation
import UIKit


/// A class that manages haptic feedback for user interactions in the app.
///
/// The `HapticsManager` class provides methods to trigger specific types of haptic feedback,
/// such as success, warning, or error notifications, using the `UINotificationFeedbackGenerator`.
/// It supports customization through the `HapticFeedbackOption` enum, allowing
/// users to set their preferred feedback type for different actions.
class HapticsManager: ObservableObject, HapticsManagerProtocol {
    
    /// A shared instance of `HapticsManager` to be used as a singleton.
    static var shared: HapticsManager = HapticsManager()
    
    /// A generator that triggers haptic feedback.
    let generator: UINotificationFeedbackGeneratable
    
    /// The user's preferred feedback type for celebration actions.
    @Published var preferredCelebrationFeedbackType: HapticFeedbackOption = .long
    
    /// The user's preferred feedback type for deletion actions.
    @Published var preferredDeletionFeedbackType: HapticFeedbackOption = .short
    
    /// Initializes a new `HapticsManager` with a customizable feedback generator.
    ///
    /// - Parameter feedbackGenerator: A type conforming to `UINotificationFeedbackGeneratable`.
    ///   The default value is `UINotificationFeedbackGenerator()`.
    init(feedbackGenerator: UINotificationFeedbackGeneratable = UINotificationFeedbackGenerator()) {
        self.generator = feedbackGenerator
    }
    
    /// Triggers a haptic feedback of the specified type.
    ///
    /// - Parameter type: The type of haptic feedback to trigger, represented by `UINotificationFeedbackGenerator.FeedbackType`.
    func vibrateDevice(for type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
    
    /// Triggers haptic feedback based on the user's preferred celebration feedback type.
    ///
    /// This method checks the `preferredCelebrationFeedbackType` and triggers the appropriate haptic feedback.
    func vibrateAddLogCelebration() {
        guard let feedbackType = preferredCelebrationFeedbackType.feedBackStyle else { return }
        vibrateDevice(for: feedbackType)
    }
    
    /// Triggers haptic feedback based on the user's preferred deletion feedback type.
    ///
    /// This method checks the `preferredDeletionFeedbackType` and triggers the appropriate haptic feedback.
    func vibrateLogRemoval() {
        guard let feedbackType = preferredDeletionFeedbackType.feedBackStyle else { return }
        vibrateDevice(for: feedbackType)
    }
}
