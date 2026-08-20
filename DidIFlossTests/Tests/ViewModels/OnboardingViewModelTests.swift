//
//  OnboardingViewModelTests.swift
//  DidIFlossTests
//

import Testing
@testable import DidIFloss

@Suite("OnboardingViewModel Tests")
struct OnboardingViewModelTests {

    @Test("continueButtonTapped triggers the onContinueTapped closure")
    func testContinueButtonTapped() {
        var didCallClosure = false
        
        let sut = OnboardingViewModel {
            didCallClosure = true
        }
        
        sut.continueButtonTapped()
        
        #expect(didCallClosure == true)
    }
}
