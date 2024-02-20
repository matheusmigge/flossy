//
//  HomeViewModel+AddLogDelegate.swift
//  DidIFloss
//
//  Created by Lucas Migge on 02/02/24.
//

import Foundation
import Notification

extension HomeViewModel: AddLogDelegate {
    func addLogRecord(date: Date) {
        
        scheduleNotifications(flossDate: date)
        persistence?.saveFlossDate(date: date)
        self.loadData()
        sheetView = nil
        showingCelebration = true
    }
    
    private func scheduleNotifications(flossDate date: Date) {
        if Calendar.current.isDateInToday(date) {
            #warning("streak count must be created")
            notificationService?.scheduleAllFlossReminders(streakCount: 3)       // streak count placeholder
        } else {
            notificationService?.scheduleInactivityFlossReminderNotifications()
        }
    }
}
