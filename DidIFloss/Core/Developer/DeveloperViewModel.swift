//
//  DeveloperViewModel.swift
//  DidIFloss
//

import Foundation
import Observation

@Observable
class DeveloperViewModel: ScreenViewModel {
    
    var feedbackGenerator: HapticsManager = HapticsManager.shared
    
    func eraseDataTapped() {
        // Here we could inject the repository/preferences to clear it
        // Or send an intent via coordinator
    }
}
