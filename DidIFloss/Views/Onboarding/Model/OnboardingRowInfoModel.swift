//
//  OnboardingRowInfoModel.swift
//  DidIFloss
//
//  Created by Lucas Migge on 01/02/24.
//

import Foundation
import SwiftUI

struct OnboardingRowInfoModel {
    let iconString: String
    let title: String
    let message: String
    
    
    struct WellcomeFeatures {
        static let calendar = OnboardingRowInfoModel(
            
            iconString: "calendar",
            title: "Keep track of your floss routine",
            message: "You can log a record every time you floss so you never miss your last floss date.")
        
        static let streak = OnboardingRowInfoModel(
            
            iconString: "checkmark.seal.fill",
            title: "Challenge yourself",
            message: "For how long can you keep your floss streak? Start today your record!")
        
        static let notifications = OnboardingRowInfoModel(
            
            iconString: "alarm",
            title: "What about a reminder?",
            message: "We know it's hard to floss everyday. We use notifications to remind you to floss if you didn't log for a while.")
    }
}
