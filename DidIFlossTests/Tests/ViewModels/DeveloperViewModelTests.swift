//
//  DeveloperViewModelTests.swift
//  DidIFlossTests
//

import XCTest
@testable import DidIFloss

final class DeveloperViewModelTests: XCTestCase {

    func test_initialization_setsFeedbackGenerator() {
        let sut = DeveloperViewModel()
        
        XCTAssertNotNil(sut.feedbackGenerator)
    }
}
