//
//  HomeViewModel.swift
//  DidIFloss
//
//  Created by Matheus Migge on 24/01/24.
//

import FlossyReminders
import FlossyRecords
import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published var sheetView: Sheet?
    @Published var showingCelebration: Bool = false
    
    @Published var showingAlert: Bool = false
    var focusedDate: Date?
    
    // MARK: Floss records
    
    @Published var flossRecords: [FlossLog] = []
    
    weak var persistence: PersistenceManagerProtocol?
    var recordsRepository: any FlossLogRepository
    let notificationService: FlossyRemindersService?
    let logInteractionHandler: HandleLogInteractionUseCaseProtocol
    
    var streakBoardViewModel: StreakBoardViewModel {
        let streakInfo = StreakCalculator.calculateCurrentStreak(logsDates: flossRecords.map({$0.date}))
        return StreakCalculator.createStreakBoardViewModel(info: streakInfo)
    }
    
    init(persistence: PersistenceManagerProtocol = PersistenceManager.shared,
         recordsRepository: any FlossLogRepository = FlossLogRepositoryFactory.make(),
         notificationService: FlossyRemindersService = FlossyRemindersServiceFactory.make(),
         logInteractionHandler: HandleLogInteractionUseCaseProtocol = HandleLogInteractionUseCase()
    ) {
        self.persistence = persistence
        self.recordsRepository = recordsRepository
        self.notificationService = notificationService
        self.logInteractionHandler = logInteractionHandler
        
       setup()
    }
    
    private func setup() {
        self.recordsRepository.delegate = self
    }
    
    // MARK: Did Appear
    
    func viewDidAppear() {
        self.checkForOnboarding()
        self.loadData()
    }
    
    func loadData() {
        Task {
            guard let records = try? await recordsRepository.fetchLogs() else { return }
            await MainActor.run {
                self.flossRecords = records
            }
        }
    }
    
    private func checkForOnboarding() {
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
        let streak = StreakCalculator.calculateCurrentStreak(logsDates: self.flossRecords.map({ $0.date }))
        
        if streak.streak == .negative || streak.streak == .empty {
            let message = "Oh no! I need to start flossing again! It's been \(streak.days) days since the last time I've flossed"
            sheetView = .shareStreak(streakInfo: message)
        }
        
        if streak.streak == .positive || streak.streak == .positiveMissingToday {
            let message = "Look at me go!! I have been flossing for \(streak.days) days straight!"
            sheetView = .shareStreak(streakInfo: message)
        }
    }
    
}

extension HomeViewModel: FlossRecordsRepositoryDelegate {
    func didUpdateLogs() {
        loadData()
    }
}
