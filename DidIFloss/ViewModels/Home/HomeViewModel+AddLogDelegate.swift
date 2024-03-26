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
        
        logInteractionHandler?.handleLogRecord(for: date)
        userFeedbackService?.vibrateAddLogCelebration()
        
        sheetView = nil
        showingCelebration = true
        
        self.loadData()
    }
}
