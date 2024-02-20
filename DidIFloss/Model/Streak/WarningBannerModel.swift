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
        WarningBannerModel(backgroundColor: .greenyBlue, text: "Seja bem vindo(a) ao Did I Floss! ☀️", textColor: .white)
    }
    
    static var userHadLoggedToday: WarningBannerModel {
        WarningBannerModel(backgroundColor: .greenyBlue, text: "O de hoje tá pago! 🫡", textColor: .white)
    }
    
    static var userHasPositiveStreak: WarningBannerModel {
        WarningBannerModel(backgroundColor: .lightYellow, text: "Você ainda não usou o fio dental hoje. Cuidado para não perder o seu combo! ⚠️", textColor: .black)
    }
    
    static var userHasNegativeStreak: WarningBannerModel {
        WarningBannerModel(backgroundColor: .flamingoPink, text: "Estamos sentindo sua falta! 🥺", textColor: .black)
    }
}
