//
//  HomeViewModel+CalendarViewDelegate.swift
//  DidIFloss
//
//  Created by Lucas Migge on 05/03/24.
//

import Foundation
import FlossyDesignSystem

extension HomeViewModel: @MainActor CalendarViewDelegate {
    func didSelectDate(_ date: Date) {
        if flossRecordsContains(date: date) {
            self.focusedDate = date
            self.showingAlert = true
            
            return
        }
        
        if isLogDateValid(for: date) {
            Task { try? await addLogRecordUseCase.execute(date: date) }
            showingCelebration = true
        }
    }

    func removeRecordsForFocusedDate() {
        guard let date = focusedDate else { return }
        
        Task { try? await removeLogRecordUseCase.execute(removeAllFor: date) }
     
        alertDismiss()
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
