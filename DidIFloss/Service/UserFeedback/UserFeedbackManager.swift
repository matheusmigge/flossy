//
//  UserFeedbackManager.swift
//  DidIFloss
//
//  Created by Lucas Migge on 22/02/24.
//

import Foundation
import UIKit

protocol UserFeedbackManagerProtocol {
    func vibrateDevice(type: UINotificationFeedbackGenerator.FeedbackType)
}


class UserFeedbackManager: UserFeedbackManagerProtocol {
    
    var generator: UINotificationFeedbackGenerator?
    
    func vibrateDevice(type: UINotificationFeedbackGenerator.FeedbackType) {
        self.generator = UINotificationFeedbackGenerator()
        generator?.notificationOccurred(type)
        

    }
    
    
}
