//
//  StreakBoardModel.swift
//  DidIFloss
//
//  Created by Matheus Migge on 01/02/24.
//

import Foundation
import SwiftUI

struct StreakBoardModel {
    var titleColor: Color
    var titleText: String
    var captionText: String
    
    static var noLogsRecorded: StreakBoardModel {
        StreakBoardModel(titleColor: .flamingoPink, titleText: "Start your streak today!", captionText: "For how long can you keep flossing every day? 👀")
    }
    
    static var firstDayOfPositiveStreak: StreakBoardModel {
        StreakBoardModel(titleColor: .greenyBlue, titleText: "Streak started!", captionText: "Keep flossing everyday to increase your record!")
    }
    
    static func positiveStreak(count: Int) -> StreakBoardModel {
        StreakBoardModel(titleColor: .greenyBlue, titleText: "\(count) day streak!", captionText: "Good work! For how long can you keep it going? 🤩")
    }
    
    static var shortNegativeStreak: StreakBoardModel {
        StreakBoardModel(titleColor: .flamingoPink, titleText: "Streak lost!", captionText: "Oh no! You were doing so well... Have you got 5 minutes to floss and restart your streak? 👀")
    }
    
    static func longNegativeStreak(count: Int) -> StreakBoardModel {
        StreakBoardModel(titleColor: .flamingoPink, titleText: "\(count) day streak!", captionText: "Looks like you're keeping a streak of not flossing your teeth! 😭")
    }
}
