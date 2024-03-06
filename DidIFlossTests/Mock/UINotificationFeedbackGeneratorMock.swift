//
//  UINotificationFeedbackGeneratorMock.swift
//  DidIFlossTests
//
//  Created by Lucas Migge on 29/02/24.
//

import Foundation
import UIKit
@testable import DidIFloss

final class UINotificationFeedbackGeneratorMock: UINotificationFeedbackGeneratable {
    
    var lastVibrationStyleTriggered: UINotificationFeedbackGenerator.FeedbackType?
    var didVibrate: Bool = false
    
    func notificationOccurred(_ notificationType: UINotificationFeedbackGenerator.FeedbackType) {
        didVibrate = true
        lastVibrationStyleTriggered = notificationType
    }
}

