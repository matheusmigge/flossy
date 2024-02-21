//
//  WarningBannerModel.swift
//  DidIFloss
//
//  Created by Matheus Migge on 30/01/24.
//

import Foundation
import SwiftUI

struct WarningBannerModel {
    var backgroundColor: Color
    var text: String
    var textColor: Color
    
    static var noLogsRecorded: WarningBannerModel {
        WarningBannerModel(backgroundColor: .greenyBlue, text: "Welcome to Flossy! ☀️", textColor: .white)
    }
    
    static var userHadLoggedToday: WarningBannerModel {
        WarningBannerModel(backgroundColor: .greenyBlue, text: "Done for the day! 🫡", textColor: .white)
    }
    
    static var userHasPositiveStreak: WarningBannerModel {
        WarningBannerModel(backgroundColor: .lightYellow, text: "You didn't floss today yet. Don't lose your streak! ⚠️", textColor: .black)
    }
    
    static var userHasNegativeStreak: WarningBannerModel {
        WarningBannerModel(backgroundColor: .flamingoPink, text: "We miss you! 🥺", textColor: .black)
    }
}
