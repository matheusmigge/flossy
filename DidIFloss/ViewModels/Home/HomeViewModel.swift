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
    var notificationService: FlossRemindersService?
    
    init(persistence: PersistenceManagerProtocol = PersistenceManager.shared, notificationService: FlossRemindersService = NotificationService.current()) {
        self.persistence = persistence
        self.persistence?.observer = self
        
        self.notificationService = notificationService
        
    }
    
    var streakBoardViewModel: StreakBoardViewModel = StreakBoardViewModel(streakBoardContent: .noLogsRecorded,
                                                                          warmingBoardContent: .noLogsRecorded)
    func updateStreakBoardViewModel(){
        let streakInfo =  StreakManager.calculateCurrentStreak(logsDates: flossRecords.map({$0.date}))
        self.streakBoardViewModel = StreakManager.createStreakBoardViewModel(info: streakInfo)
    }
    
    // MARK: Did Apper
    
    func viewDidApper() {
        self.loadData()
        self.checkForOnboarding()
        
    }
    
    func loadData() {
        persistence?.getFlossRecords { [weak self] records in
            self?.flossRecords = records
            self?.updateStreakBoardViewModel()
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
    
    private func flossRecordsContains(date: Date) -> Bool {
        var recordsDateSignatures: Set<String> = Set()
        
        flossRecords.forEach { recordsDateSignatures.insert($0.date.calendarSignature) }
        
        return recordsDateSignatures.contains(date.calendarSignature)
    }
    
}

extension HomeViewModel: CalendarViewDelegate {
    func didSelectDate(_ date: Date) {
        if flossRecordsContains(date: date) {
            self.focusedDate = date
            self.showingAlert = true
            
            return
        }
        
        
        if !Calendar.isDateInTheFuture(date) && !showingCelebration {
            let calendarComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
            let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: .now)
            
            let logDate = Calendar.createDate(year: calendarComponents.year, month: calendarComponents.month, day: calendarComponents.day, hour: timeComponents.hour, minute: timeComponents.minute)
            
            addLogRecord(date: logDate ?? date)
            
        }
        
    }
    
    func alertDismiss() {
        showingAlert = false
        self.focusedDate = nil
    }
    
    func removeRecordsForFocusedDate() {
        guard let date = focusedDate else { return }
        
        var selectedRecords: [FlossRecord] {
            self.flossRecords.filter { Calendar.current.isDate($0.date, inSameDayAs: date)}
        }
        
        persistence?.deleteFlossRecords(selectedRecords)
        
        alertDismiss()
        self.loadData()
        
    }
}
