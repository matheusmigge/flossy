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
        
        if Calendar.current.isDateInToday(date) {
            notificationService?.clearPendingDailyStreakFlossReminderNotification()
            
        }
      
        alertDismiss()
        self.loadData()
    }
}
