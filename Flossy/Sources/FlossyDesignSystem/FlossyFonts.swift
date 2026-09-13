//
//  FlossyFonts.swift
//  Flossy
//
//  Created by Lucas Migge de Barros on 20/08/26.
//

import SwiftUI
import CoreText
import Foundation

public enum FlossyFonts {
    public static func registerFonts() {
        guard let url = Bundle.module.url(forResource: "Borel-Regular", withExtension: "ttf") else {
            print("Failed to find font in module bundle")
            return
        }
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error) {
            print("Failed to register font: \(String(describing: error))")
        }
    }
    
    public static func borel(size: CGFloat) -> Font {
        return Font.custom("Borel-Regular", size: size)
    }
}
