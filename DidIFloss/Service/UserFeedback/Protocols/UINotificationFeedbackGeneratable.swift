//
//  UINotificationFeedbackGeneratable.swift
//  DidIFloss
//
//  Created by Lucas Migge on 29/02/24.
//

import Foundation
import UIKit

protocol UINotificationFeedbackGeneratable {
    func notificationOccurred(_ notificationType: UINotificationFeedbackGenerator.FeedbackType)
    
}
