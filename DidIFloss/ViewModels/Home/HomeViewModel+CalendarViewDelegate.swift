//
//  HomeViewModel+CalendarViewDelegate.swift
//  DidIFloss
//
//  Created by Lucas Migge on 05/03/24.
//

import Foundation

extension HomeViewModel: CalendarViewDelegate {
    func didSelectDate(_ date: Date) {
        if flossRecordsContains(date: date) {
            self.focusedDate = date
            self.showingAlert = true
            
            return
        }
        
        
        if isLogDateValid(for: date) {
            addLogRecord(date: date)
        }
    }

    func removeRecordsForFocusedDate() {
        guard let date = focusedDate else { return }
        
        logInteractionHandler?.handleLogRecord(for: date)
      
        userFeedbackService?.vibrateLogRemoval()
        alertDismiss()
        self.loadData()
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
