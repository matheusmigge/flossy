//
//  AddFlossViewModel.swift
//  DidIFloss
//

import Foundation
import SwiftUI
import Observation
import FlossyCore

@MainActor
@Observable
class AddFlossViewModel: ScreenViewModel {
    
    var selectedDate: Date = .now
    
    private let flossLogService: FlossLogServicing
    private let hapticsManager: HapticsManagerProtocol
    private weak var coordinatorDelegate: HomeCoordinatorDelegate?
    
    @MainActor
    init(flossLogService: (any FlossLogServicing)? = nil,
         hapticsManager: HapticsManagerProtocol? = nil,
         coordinatorDelegate: HomeCoordinatorDelegate? = nil) {
        self.flossLogService = flossLogService ?? FlossLogServiceFactory.make()
        self.hapticsManager = hapticsManager ?? HapticsManager()
        self.coordinatorDelegate = coordinatorDelegate
    }
    
    var isSelectedDateValid: Bool {
        flossLogService.isDateValid(selectedDate)
    }
    
    func addLogRecord() async {
        guard isSelectedDateValid else { return }
        
        do {
            try await flossLogService.addLogRecord(date: selectedDate)
            hapticsManager.vibrateAddLogCelebration()
            coordinatorDelegate?.addLogDidComplete()
        } catch {
            // Handle error if needed
            print("Failed to save log: \(error)")
        }
    }
}
