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
        guard let safePersistence = persistence else { return }
        
        safePersistence.saveFlossDate(date: date)
        self.loadData()
        sheetView = nil
        showingCelebration = true
    }

}
