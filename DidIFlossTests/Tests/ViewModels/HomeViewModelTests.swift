import Testing
import Foundation
import Combine
@testable import DidIFloss
import FlossyData
import FlossyReminders
import FlossyStreak

@MainActor
@Suite("HomeViewModel Tests")
struct HomeViewModelTests {
    
    class HomeCoordinatorDelegateMock: HomeCoordinatorDelegate {
        var didTapAddLogButtonCallCount = 0
        func didTapAddLogButton() {
            didTapAddLogButtonCallCount += 1
        }
        
        var didTapDeveloperOptionsCallCount = 0
        func didTapDeveloperOptions() {
            didTapDeveloperOptionsCallCount += 1
        }
        
        var didTapShareStreakCallCount = 0
        var sharedStreakMessage: String?
        func didTapShareStreak(streakMessage: String) {
            didTapShareStreakCallCount += 1
            sharedStreakMessage = streakMessage
        }
        
        var didTapLogRecordsCallCount = 0
        func didTapLogRecords() {
            didTapLogRecordsCallCount += 1
        }
        
        var needsOnboardingCallCount = 0
        func needsOnboarding() {
            needsOnboardingCallCount += 1
        }
        
        func onboardingDidComplete() {}
        func addLogDidComplete() {}
    }
    
    final class StreakAnalyzerMock: StreakAnalyzer, @unchecked Sendable {
        var mockedState: StreakState = .noHistory
        func analyze(logDates: [Date]) -> StreakState {
            return mockedState
        }
        
        func analyze(logDates: [Date], referenceDate: Date, calendar: Calendar) -> StreakState {
            return mockedState
        }
    }
    
    @Test("Load data fetches logs and updates properties")
    func loadData() async {
        // Given
        let mockRepo = FlossLogRepositoryMock()
        let log = FlossLog(flossDate: Date())
        mockRepo.fetchedLogs = [log]
        
        let sut = HomeViewModel(
            persistence: AppPreferences(userDefaults: UserDefaults.standard),
            recordsRepository: mockRepo,
            notificationService: FlossyRemindersServiceFactory.make(),
            addLogRecordUseCase: AddLogRecordUseCaseMock(), removeLogRecordUseCase: RemoveLogRecordUseCaseMock(),
            streakAnalyzer: StreakAnalyzerMock()
        )
        
        // When
        await sut.loadData()
        
        // Then
        #expect(sut.flossRecords.count == 1)
        #expect(sut.flossRecords.first?.id == log.id)
    }
    
    @Test("Combine subscription updates properties when repo emits")
    func setupBindings() async throws {
        // Given
        let mockRepo = FlossLogRepositoryMock()
        let sut = HomeViewModel(
            recordsRepository: mockRepo,
            streakAnalyzer: StreakAnalyzerMock()
        )
        
        #expect(sut.flossRecords.isEmpty)
        
        // When
        let log = FlossLog(flossDate: Date())
        mockRepo.subject.send([log])
        
        // Yield to allow main thread dispatch to process Combine event
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        #expect(sut.flossRecords.count == 1)
        #expect(sut.flossRecords.first?.id == log.id)
    }
    
    @Test("Plus button delegates correctly when not showing celebration")
    func plusButtonPressed() {
        let sut = HomeViewModel()
        let delegateMock = HomeCoordinatorDelegateMock()
        sut.coordinatorDelegate = delegateMock
        
        sut.showingCelebration = false
        sut.plusButtonPressed()
        
        #expect(delegateMock.didTapAddLogButtonCallCount == 1)
    }
    
    @Test("Plus button ignores tap when showing celebration")
    func plusButtonPressedWhileCelebrating() {
        let sut = HomeViewModel()
        let delegateMock = HomeCoordinatorDelegateMock()
        sut.coordinatorDelegate = delegateMock
        
        sut.showingCelebration = true
        sut.plusButtonPressed()
        
        #expect(delegateMock.didTapAddLogButtonCallCount == 0)
    }
    
    @Test("Share sheet delegates correctly with proper message")
    func presentShareSheet() {
        let mockAnalyzer = StreakAnalyzerMock()
        mockAnalyzer.mockedState = .startedToday
        let sut = HomeViewModel(streakAnalyzer: mockAnalyzer)
        let delegateMock = HomeCoordinatorDelegateMock()
        sut.coordinatorDelegate = delegateMock
        
        sut.presentShareSheet()
        
        #expect(delegateMock.didTapShareStreakCallCount == 1)
        #expect(delegateMock.sharedStreakMessage == "Look at me go! I started flossing today!")
    }
    
    @Test("goToLogRecords delegates correctly")
    func goToLogRecords() {
        let sut = HomeViewModel()
        let delegateMock = HomeCoordinatorDelegateMock()
        sut.coordinatorDelegate = delegateMock
        
        sut.goToLogRecords()
        
        #expect(delegateMock.didTapLogRecordsCallCount == 1)
    }
}
