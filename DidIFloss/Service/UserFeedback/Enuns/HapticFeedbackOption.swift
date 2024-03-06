//
//  HapticFeedbackOption.swift
//  DidIFloss
//
//  Created by Lucas Migge on 22/02/24.
//

import Foundation
import UIKit

enum HapticFeedbackOption: Hashable {
    case short, medium, long, none
    
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
