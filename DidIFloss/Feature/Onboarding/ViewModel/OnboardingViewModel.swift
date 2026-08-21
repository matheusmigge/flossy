//
//  OnboardingViewModel.swift
//  DidIFloss
//

import Foundation
import Observation

import FlossyReminders

@MainActor
@Observable
class OnboardingViewModel: ScreenViewModel {
    
    private let notificationService: FlossyRemindersService?
    private weak var coordinatorDelegate: HomeCoordinatorDelegate?
    
    init(notificationService: FlossyRemindersService? = FlossyRemindersServiceFactory.make(),
         coordinatorDelegate: HomeCoordinatorDelegate? = nil) {
        self.notificationService = notificationService
        self.coordinatorDelegate = coordinatorDelegate
    }
    
    func continueButtonTapped() {
        notificationService?.requestAuthorizationToNotificate(provisional: false)
        coordinatorDelegate?.onboardingDidComplete()
    }
}
