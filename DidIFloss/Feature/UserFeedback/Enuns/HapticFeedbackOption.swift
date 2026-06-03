//
//  HapticFeedbackOption.swift
//  DidIFloss
//
//  Created by Lucas Migge on 22/02/24.
//

import Foundation
import UIKit

/// An enumeration representing different haptic feedback options.
///
/// The `HapticFeedbackOption` enum allows customization of haptic feedback
/// styles, including short, medium, long, or none.
enum HapticFeedbackOption: Hashable {
    /// A short haptic feedback, corresponding to a `.success` feedback style.
    case short
    
    /// A medium haptic feedback, corresponding to a `.warning` feedback style.
    case medium
    
    /// A long haptic feedback, corresponding to an `.error` feedback style.
    case long
    
    /// No haptic feedback.
    case none
    
    /// Maps the `HapticFeedbackOption` to a `UINotificationFeedbackGenerator.FeedbackType`.
    ///
    /// - Returns: A `UINotificationFeedbackGenerator.FeedbackType` or `nil` if `none` is selected.
    var feedBackStyle: UINotificationFeedbackGenerator.FeedbackType? {
        switch self {
        case .short:
            return .success
        case .medium:
            return .warning
        case .long:
            return .error
        case .none:
            return nil
        }
    }
}
