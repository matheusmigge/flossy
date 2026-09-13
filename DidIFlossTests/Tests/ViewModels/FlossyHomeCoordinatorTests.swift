import Testing
import Foundation
import FlossyCore
@testable import DidIFloss
import FlossyData
import SwiftUI

@MainActor
@Suite("FlossyHomeCoordinator Tests")
struct FlossyHomeCoordinatorTests {
    
    final class MockAppPreferences: AppPreferencesProtocol, @unchecked Sendable {
        var didCheckIsNewUser = false
        var isNewUserMock = false
        
        func checkIfIsNewUser() -> Bool {
            didCheckIsNewUser = true
            return isNewUserMock
        }
    }
    
    @Test("Coordinator should present onboarding on initialization if new user")
    func checkNewUserInit() {
        let prefs = MockAppPreferences()
        prefs.isNewUserMock = true
        
        let sut = FlossyHomeCoordinator(
            persistence: prefs
        )
        
        #expect(prefs.didCheckIsNewUser)
        
        switch sut.presentingSheet {
        case .welcomeSheet:
            // Success
            break
        default:
            Issue.record("Expected welcomeSheet but got \(String(describing: sut.presentingSheet))")
        }
    }
    
    @Test("Coordinator should not present onboarding on initialization if returning user")
    func checkReturningUserInit() {
        let prefs = MockAppPreferences()
        prefs.isNewUserMock = false
        
        let sut = FlossyHomeCoordinator(
            persistence: prefs
        )
        
        #expect(prefs.didCheckIsNewUser)
        #expect(sut.presentingSheet == nil)
    }
    
    @Test("didTapAddLogButton should set presentingSheet to addLogSheet")
    func didTapAddLogButton() {
        let sut = FlossyHomeCoordinator()
        
        sut.didTapAddLogButton()
        
        switch sut.presentingSheet {
        case .addLogSheet:
            break
        default:
            Issue.record("Expected addLogSheet")
        }
    }
    
    
    @Test("didTapLogRecords should append logRecords to navigation path")
    func didTapLogRecords() {
        let sut = FlossyHomeCoordinator()
        
        sut.didTapLogRecords()
        
        #expect(sut.path.count == 1)
    }
    
    @Test("addLogDidComplete should dismiss sheet and show celebration")
    func addLogDidComplete() {
        let sut = FlossyHomeCoordinator()
        sut.presentingSheet = .welcomeSheet(OnboardingViewModel()) // dummy value
        
        sut.addLogDidComplete()
        
        #expect(sut.presentingSheet == nil)
        #expect(sut.homeViewModel.showingCelebration == true)
    }
    
    @Test("onboardingDidComplete should dismiss sheet")
    func onboardingDidComplete() {
        let sut = FlossyHomeCoordinator()
        sut.presentingSheet = .welcomeSheet(OnboardingViewModel())
        
        sut.onboardingDidComplete()
        
        #expect(sut.presentingSheet == nil)
    }
}
