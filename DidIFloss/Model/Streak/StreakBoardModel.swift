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
        StreakBoardModel(titleColor: .greenyBlue, titleText: "Comece seu combo hoje!", captionText: "Até quantos dias seguidos você consegue se manter passando o fio dental? 👀")
    }
    
    static var firstDayOfPositiveStreak: StreakBoardModel {
        StreakBoardModel(titleColor: .greenyBlue, titleText: "Combo iniciado!", captionText: "Continue passando o fio dental todos os dias para manter o seu combo.")
    }
    
    static func positiveStreak(count: Int) -> StreakBoardModel {
        StreakBoardModel(titleColor: .greenyBlue, titleText: "\(count) dias seguidos!", captionText: "É isso aí! Até quantos dias você consegue manter o combo? 👀")
    }
    
    static var shortNegativeStreak: StreakBoardModel {
        StreakBoardModel(titleColor: .flamingoPink, titleText: "Combo perdido!", captionText: "Oh não! Você estava indo tão bem... Tem 5 minutinhos para passar o fio dental e recomeçar o seu combo? 👀")
    }
    
    static func longNegativeStreak(count: Int) -> StreakBoardModel {
        StreakBoardModel(titleColor: .flamingoPink, titleText: "\(count) dias seguidos!", captionText: "Parece que você está acumulando um combo de dias seguidos sem passar o fio dental! 😭 ")
    }
}
