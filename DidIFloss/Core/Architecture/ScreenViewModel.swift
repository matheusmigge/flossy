//
//  ScreenViewModel.swift
//  DidIFloss
//

import Foundation
import SwiftUI

public protocol ScreenViewModel: AnyObject, Observable {
    func onAppear()
    func onDisappear()
}

public extension ScreenViewModel {
    func onAppear() {}
    func onDisappear() {}
}

// indicates that the View is a Page Screen
public protocol Screen: View {
    
}
