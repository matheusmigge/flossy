//
//  ScreenViewModel.swift
//  DidIFloss
//

import Foundation


public protocol ScreenViewModel: AnyObject, Observable {
    func onAppear()
    func onDisappear()
}

public extension ScreenViewModel {
    func onAppear() {}
    func onDisappear() {}
}
