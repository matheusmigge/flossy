//
//  UINotificationFeedbackGeneratable.swift
//  DidIFloss
//
//  Created by Lucas Migge on 29/02/24.
//

import Foundation
import UIKit

/// A protocol that defines the behavior of a haptic feedback generator.
///
/// This protocol is used to abstract the `UINotificationFeedbackGenerator` for testing
/// and customization purposes.
protocol UINotificationFeedbackGeneratable {
    
    /// Triggers a haptic feedback of the specified type.
    ///
    /// - Parameter notificationType: The type of haptic feedback to trigger.
    func notificationOccurred(_ notificationType: UINotificationFeedbackGenerator.FeedbackType)
}
