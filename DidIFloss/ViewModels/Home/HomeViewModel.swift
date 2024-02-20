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
    
    // MARK: Floss records
    
    @Published var flossRecords: [FlossRecord] = []
    
    weak var persistence: PersistenceManagerProtocol?
    var notificationService: FlossRemindersService?
    
    init(persistence: PersistenceManagerProtocol = PersistenceManager.shared, notificationService: FlossRemindersService = NotificationService.current()) {
        self.persistence = persistence
        self.persistence?.observer = self
        
        self.notificationService = notificationService
        
    }
    
    var streakBoardViewModel: StreakBoardViewModel {
        let streakInfo =  StreakManager.calculateCurrentStreak(logsDates: flossRecords.map({$0.date}))
        return StreakManager.createStreakBoardViewModel(info: streakInfo)
    }
    
    
    // MARK: Did Apper

    func viewDidApper() {
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

}

