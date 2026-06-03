//
//  UINotificationFeedbackGenerator.swift
//  DidIFloss
//
//  Created by Lucas Migge on 29/02/24.
//

import Foundation
import UIKit

/// Extends `UINotificationFeedbackGenerator` to conform to `UINotificationFeedbackGeneratable`.
///
/// This extension allows `UINotificationFeedbackGenerator` to be used where a
/// `UINotificationFeedbackGeneratable` instance is required, enabling abstraction
/// and easier testing of haptic feedback functionality.
extension UINotificationFeedbackGenerator: UINotificationFeedbackGeneratable {
    
}

