//
//  OnboardingViewModel.swift
//  DidIFloss
//

import Foundation
import Observation

@MainActor
@Observable
class OnboardingViewModel: ScreenViewModel {
    
    weak var delegate: OnboardingDelegate?
    
    init(delegate: OnboardingDelegate? = nil) {
        self.delegate = delegate
    }
    
    func continueButtonTapped() {
        delegate?.onboardingDidComplete()
    }
}
