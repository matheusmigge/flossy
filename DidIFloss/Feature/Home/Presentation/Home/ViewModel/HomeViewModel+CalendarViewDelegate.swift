//
//  HomeViewModel+CalendarViewDelegate.swift
//  DidIFloss
//
//  Created by Lucas Migge on 05/03/24.
//

import Foundation
import FlossyDesignSystem
import FlossyCore

extension HomeViewModel: @MainActor CalendarViewDelegate {
    func didSelectDate(_ date: Date) {
        if flossRecordsContains(date: date) {
            self.focusedDate = date
            self.showingAlert = true
            
            return
        }
        
        if isLogDateValid(for: date) {
            Task { 
                try? await flossLogService.addLogRecord(date: date) 
                hapticsManager.vibrateAddLogCelebration()
            }
            showingCelebration = true
        }
    }

    func removeRecordsForFocusedDate() {
        guard let date = focusedDate else { return }
        
        removeRecordFor(date: date)
     
        alertDismiss()
    }
    
    func removeRecordFor(date: Date) {
        Task { 
            try? await flossLogService.removeLogs(removeAllFor: date) 
            hapticsManager.vibrateLogRemoval()
        }
    }
    
    func alertDismiss() {
        showingAlert = false
        self.focusedDate = nil
    }
    
    private func flossRecordsContains(date: Date) -> Bool {
        var recordsDateSignatures: Set<String> = Set()
        
        flossRecords.forEach { recordsDateSignatures.insert($0.date.calendarSignature) }
        
        return recordsDateSignatures.contains(date.calendarSignature)
    }
    
    private func isLogDateValid(for date: Date) -> Bool {
        return !Calendar.isDateInTheFuture(date) && !showingCelebration
    }
}
