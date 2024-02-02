//
//  Constants.swift
//  DidIFloss
//
//  Created by Matheus Migge on 01/01/24.
//

import Foundation
import SwiftUI

struct Constants {
    
    struct FontNames {
        static let borel = "Borel-Regular"
    }
    
    struct ImageNames {
        static let toothPink = "pink-tooth"
        static let toothYellow = "yellow-tooth"
    }
}

extension Color {
    
    private struct ColorNames {
        static let skyBlue = "sky-blue"
        static let lightYellow = "light-yellow"
        static let flamingoPink = "flamingo-pink"
        static let greenyBlue = "greeny-blue"
    }
    
    static let flossSkyBlue = Color(ColorNames.skyBlue)
    static let flossLightYellow = Color(ColorNames.lightYellow)
    static let flossFlamingoPink = Color(ColorNames.flamingoPink)
    static let flossGreenyBlue = Color(ColorNames.greenyBlue)
}
