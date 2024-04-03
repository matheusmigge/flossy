//
//  HomeViewModel.swift
//  DidIFloss
//
//  Created by Matheus Migge on 24/01/24.
//

import Foundation
import Notification
import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published var sheetView: Sheet?
    @Published var showingCelebration: Bool = false
    
    @Published var showingAlert: Bool = false
    var focusedDate: Date?
    
    // MARK: Floss records
    
    @Published var flossRecords: [FlossRecord] = []
    
    weak var persistence: PersistenceManagerProtocol?
    weak var notificationService: FlossRemindersService?
    weak var userFeedbackService: HapticsManagerProtocol?
    var logInteractionHandler: HandleLogInteractionUseCaseProtocol
    
    var streakBoardViewModel: StreakBoardViewModel {
        let streakInfo = StreakCalculator.calculateCurrentStreak(logsDates: flossRecords.map({$0.date}))
        return StreakCalculator.createStreakBoardViewModel(info: streakInfo)
    }
    
    init(persistence: PersistenceManagerProtocol = PersistenceManager.shared,
         notificationService: FlossRemindersService = NotificationService.current(),
         userFeedbackService: HapticsManagerProtocol = HapticsManager.shared,
         logInteractionHandler: HandleLogInteractionUseCaseProtocol = HandleLogInteractionUseCase()
    ) {
        self.persistence = persistence
        self.notificationService = notificationService
        self.userFeedbackService = userFeedbackService
        self.logInteractionHandler = logInteractionHandler
    }
    
    // MARK: Did Apper
    
    func viewDidApper() {
        self.persistence?.delegate = self
        
        self.loadData()
        self.checkForOnboarding()
        
    }
    
    func loadData() {
        persistence?.getFlossRecords { [weak self] records in
            self?.flossRecords = records
        }
    }
    
    private func checkForOnboarding() {
        // should show onboard?
        guard let safePersistence = persistence else { return }
        
        if safePersistence.checkIfIsNewUser() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.sheetView = .welcomeSheet
            }
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

