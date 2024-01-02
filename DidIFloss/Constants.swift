//
//  Constants.swift
//  DidIFloss
//
//  Created by Matheus Migge on 01/01/24.
//

import Foundation
import SwiftUI

struct Constants {
    struct ColorNames {
        static let skyBlue = "sky-blue"
        static let lightYellow = "light-yellow"
        static let flamingoPink = "flamingo-pink"
    }
    
    struct FontNames {
        static let borel = "Borel-Regular"
    }
    
    struct ImageNames {
        static let toothPink = "pink-tooth"
        static let toothYellow = "yellow-tooth"
    }
}

extension Color {
    static let flossSkyBlue = Color(Constants.ColorNames.skyBlue)
    static let flossLightYellow = Color(Constants.ColorNames.lightYellow)
    static let flossFlamingoPink = Color(Constants.ColorNames.flamingoPink)
}
