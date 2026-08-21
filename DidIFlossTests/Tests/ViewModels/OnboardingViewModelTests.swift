//
//  OnboardingViewModelTests.swift
//  DidIFlossTests
//

import Testing
import FlossyReminders
@testable import DidIFloss

@MainActor
@Suite("OnboardingViewModel Tests")
struct OnboardingViewModelTests {

    class MockHomeCoordinatorDelegate: HomeCoordinatorDelegate {
        var didCallOnboardingComplete = false
        
        func didTapAddLogButton() {}
        func didTapShareStreak(streakMessage: String) {}
        func didTapLogRecords() {}
        func didTapDeveloperOptions() {}
        func onboardingDidComplete() {
            didCallOnboardingComplete = true
        }
        func addLogDidComplete() {}
    }

    @Test("continueButtonTapped triggers coordinatorDelegate")
    func testContinueButtonTapped() {
        let mockCoordinator = MockHomeCoordinatorDelegate()
        let sut = OnboardingViewModel(notificationService: nil, coordinatorDelegate: mockCoordinator)
        
        sut.continueButtonTapped()
        
        #expect(mockCoordinator.didCallOnboardingComplete == true)
    }
}
