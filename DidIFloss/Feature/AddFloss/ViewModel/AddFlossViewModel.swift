//
//  AddFlossViewModel.swift
//  DidIFloss
//

import Foundation
import SwiftUI
import Observation

@MainActor
@Observable
class AddFlossViewModel: ScreenViewModel {
    
    var selectedDate: Date = .now
    
    private let logRecordsHandler: HandleLogInteractionUseCaseProtocol
    private weak var coordinatorDelegate: HomeCoordinatorDelegate?
    
    init(logRecordsHandler: HandleLogInteractionUseCaseProtocol = HandleLogInteractionUseCase(),
         coordinatorDelegate: HomeCoordinatorDelegate? = nil) {
        self.logRecordsHandler = logRecordsHandler
        self.coordinatorDelegate = coordinatorDelegate
    }
    
    var isSelectedDateValid: Bool {
        selectedDate < .now
    }
    
    func addLogRecord() {
        if isSelectedDateValid {
            logRecordsHandler.handleLogRecord(for: selectedDate)
            coordinatorDelegate?.addLogDidComplete()
        }
    }
}
