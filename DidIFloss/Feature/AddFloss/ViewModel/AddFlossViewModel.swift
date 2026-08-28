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
    
    private let addLogRecordUseCase: AddLogRecordUseCaseProtocol
    private weak var coordinatorDelegate: HomeCoordinatorDelegate?
    
    init(addLogRecordUseCase: AddLogRecordUseCaseProtocol = AddLogRecordUseCase(),
         coordinatorDelegate: HomeCoordinatorDelegate? = nil) {
        self.addLogRecordUseCase = addLogRecordUseCase
        self.coordinatorDelegate = coordinatorDelegate
    }
    
    var isSelectedDateValid: Bool {
        addLogRecordUseCase.isDateValid(selectedDate)
    }
    
    func addLogRecord() {
        guard isSelectedDateValid else { return }
        
        Task {
            do {
                try await addLogRecordUseCase.execute(date: selectedDate)
                coordinatorDelegate?.addLogDidComplete()
            } catch {
                // Handle error if needed
                print("Failed to save log: \(error)")
            }
        }
    }
}
