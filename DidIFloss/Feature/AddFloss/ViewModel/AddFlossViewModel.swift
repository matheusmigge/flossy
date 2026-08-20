//
//  AddFlossViewModel.swift
//  DidIFloss
//

import Foundation
import SwiftUI
import Observation

@Observable
class AddFlossViewModel: ScreenViewModel {
    
    var selectedDate: Date = .now
    weak var delegate: AddFlossDelegate?
    
    init(delegate: AddFlossDelegate? = nil) {
        self.delegate = delegate
    }
    
    var isSelectedDateValid: Bool {
        selectedDate < .now
    }
    
    func addLogRecord() {
        if isSelectedDateValid {
            delegate?.addLogRecord(date: selectedDate)
        }
    }
}
