//
//  HomeViewModel+AddLogDelegate.swift
//  DidIFloss
//
//  Created by Lucas Migge on 02/02/24.
//

import Foundation

extension HomeViewModel: @MainActor AddFlossDelegate {
    func addLogRecord(date: Date) {
        logInteractionHandler.handleLogRecord(for: date)
        
        coordinatorDelegate?.addLogDidComplete()
        showingCelebration = true
        
        Task {
            await self.loadData()
        }
    }
}
