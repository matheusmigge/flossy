//
//  OnboardingViewModelTests.swift
//  DidIFlossTests
//

import XCTest
@testable import DidIFloss

final class OnboardingViewModelTests: XCTestCase {

    func test_continueButtonTapped_callsClosure() {
        var didCallClosure = false
        
        let sut = OnboardingViewModel {
            didCallClosure = true
        }
        
        sut.continueButtonTapped()
        
        XCTAssertTrue(didCallClosure)
    }
}
