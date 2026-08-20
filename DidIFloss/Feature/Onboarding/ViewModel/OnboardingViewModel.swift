//
//  OnboardingViewModel.swift
//  DidIFloss
//

import Foundation
import Observation

@Observable
class OnboardingViewModel: ScreenViewModel {
    
    var onContinueTapped: (() -> Void)?
    
    init(onContinueTapped: (() -> Void)? = nil) {
        self.onContinueTapped = onContinueTapped
    }
    
    func continueButtonTapped() {
        onContinueTapped?()
    }
}
