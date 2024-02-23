//
//  HapticFeedbackOption.swift
//  DidIFloss
//
//  Created by Lucas Migge on 22/02/24.
//

import Foundation
import UIKit

enum HapticFeedbackOption: Hashable {
    case success, warning, error, none
    
    var feedBackStyle: UINotificationFeedbackGenerator.FeedbackType? {
        switch self {
        case .success:
            return .success
        case .warning:
            return .warning
        case .error:
            return .error
        case .none:
            return nil
        }
    }
    
}
