//
//  HomeViewModel+AddLogDelegate.swift
//  DidIFloss
//
//  Created by Lucas Migge on 02/02/24.
//

import Foundation

extension HomeViewModel: AddLogDelegate {
    func addLogRecord(date: Date) {
        guard let safePersistence = persistence else { return }
        
        safePersistence.saveLastFlossDate(date: date)
        self.loadData()
        sheetView = nil
        showingCelebration = true
    }
    
    func plusButtonPressed() {
        sheetView = .addLogSheet
    }
}
