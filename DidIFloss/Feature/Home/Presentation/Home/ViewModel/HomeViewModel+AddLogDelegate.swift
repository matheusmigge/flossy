//
//  HomeViewModel+AddLogDelegate.swift
//  DidIFloss
//
//  Created by Lucas Migge on 02/02/24.
//

import Foundation

extension HomeViewModel: AddFlossDelegate {
    func addLogRecord(date: Date) {
        logInteractionHandler.handleLogRecord(for: date)
        
        sheetView = nil
        showingCelebration = true
        
        self.loadData()
    }
}
