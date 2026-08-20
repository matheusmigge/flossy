//
//  DeveloperViewModelTests.swift
//  DidIFlossTests
//

import Testing
@testable import DidIFloss

@Suite("DeveloperViewModel Tests")
struct DeveloperViewModelTests {

    @Test("Initialization sets feedbackGenerator correctly")
    func testInitialization() {
        let sut = DeveloperViewModel()
        
        #expect(sut.feedbackGenerator != nil)
    }
}
