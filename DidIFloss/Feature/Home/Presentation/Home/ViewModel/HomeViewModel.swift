//
//  HomeViewModel.swift
//  DidIFloss
//
//  Created by Matheus Migge on 24/01/24.
//

import FlossyReminders
import FlossyRecords
import FlossyStreak
import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    
    @Published var sheetView: Sheet?
    @Published var showingCelebration: Bool = false
    
    @Published var showingAlert: Bool = false
    var focusedDate: Date?
    
    // MARK: Floss records
    
    @Published var flossRecords: [FlossLog] = []
    
    weak var persistence: AppPreferencesProtocol?
    var recordsRepository: any FlossLogRepository
    let notificationService: FlossyRemindersService?
    let logInteractionHandler: HandleLogInteractionUseCaseProtocol
    let streakAnalyzer: any StreakAnalyzer
    
    var streakBoardViewModel: StreakBoardViewModel {
        let state = streakAnalyzer.analyze(logDates: flossRecords.map({ $0.date }))
        return StreakBoardPresenter.makeViewModel(from: state)
    }
    
    init(persistence: AppPreferencesProtocol = AppPreferences.shared,
         recordsRepository: any FlossLogRepository = DefaultFlossLogRepositoryFactory.make(),
         notificationService: FlossyRemindersService = FlossyRemindersServiceFactory.make(),
         logInteractionHandler: HandleLogInteractionUseCaseProtocol = HandleLogInteractionUseCase(),
         streakAnalyzer: any StreakAnalyzer = DefaultStreakAnalyzer()
    ) {
        self.persistence = persistence
        self.recordsRepository = recordsRepository
        self.notificationService = notificationService
        self.logInteractionHandler = logInteractionHandler
        self.streakAnalyzer = streakAnalyzer
    }
    
    
    // MARK: Did Appear
    
    func viewDidAppear() async {
        await recordsRepository.setDelegate(self)
        
        await withDiscardingTaskGroup { [weak self] group in
            group.addTask { await self?.checkForOnboarding() }
            group.addTask { await self?.loadData() }
        }
        
    }
    
    func loadData() async {
        guard let records = try? await recordsRepository.fetchLogs() else { return }
        await MainActor.run {
            self.flossRecords = records
            
        }
    }
    
    private func checkForOnboarding() async {
        // should show onboard?
        guard let safePersistence = persistence else { return }
        
        if safePersistence.checkIfIsNewUser() {
            self.sheetView = .welcomeSheet
        }
    }
    
    func onboardingOver() {
        notificationService?.requestAuthorizationToNotificate(provisional: false)
        
    }
    
    func plusButtonPressed() {
        if !showingCelebration {
            sheetView = .addLogSheet
        }
    }
    
    func goToDeveloperView() {
#if DEBUG
        sheetView = .developerSheet
#endif
        
    }
    
    func presentShareSheet() {
        let state = streakAnalyzer.analyze(logDates: flossRecords.map{ $0.date })
        let message = ShareStreakMessageFactory.makeMessage(from: state)
        sheetView = .shareStreak(streakInfo: message)
    }
    
}

extension HomeViewModel: FlossRecordsRepositoryDelegate {
    nonisolated func didUpdateLogs() {
        Task {
            await loadData()
        }
    }
}


extension HomeViewModel {
    struct StreakBoardPresenter {
        static func makeViewModel(from state: StreakState) -> StreakBoardViewModel {
            switch state {
            case .noHistory:
                return .init(streakBoardContent: .noLogsRecorded, warmingBoardContent: .noLogsRecorded)
            case .startedToday:
                return .init(streakBoardContent: .firstDayOfPositiveStreak, warmingBoardContent: .userHadLoggedToday)
            case .activePendingToday(let days):
                return .init(streakBoardContent: .positiveStreak(count: days), warmingBoardContent: .userHasPositiveStreak)
            case .activeCompletedToday(let days):
                return .init(streakBoardContent: .positiveStreak(count: days), warmingBoardContent: .userHadLoggedToday)
            case .inactive(let days):
                let content: StreakBoardModel = days < 3
                ? .shortNegativeStreak
                : .longNegativeStreak(count: days)
                
                return .init(streakBoardContent: content, warmingBoardContent: .userHasNegativeStreak)
            }
        }
    }
    
    struct ShareStreakMessageFactory {
        static func makeMessage(from state: StreakState) -> String {
            switch state {
            case .noHistory:
                return "I'm starting my flossing streak today!"
            case .startedToday:
                return "Look at me go! I started flossing today!"
            case .activePendingToday(days: let days), .activeCompletedToday(days: let days):
                return "Look at me go! I have been flossing for \(days) days straight!"
            case .inactive(daysSinceLastLog: let days):
                return "Oh no! I need to start flossing again! It's been \(days) days since the last time I've flossed"

            }
        }
    }
}
