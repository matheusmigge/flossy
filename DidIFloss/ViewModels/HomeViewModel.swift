//
//  HomeViewModel.swift
//  DidIFloss
//
//  Created by Matheus Migge on 24/01/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var isPresentingAddLogSheet: Bool = false
    @Published var isPresentingOnboardingSheet = true
    
    // MARK: Floss records
    
    @Published var flossRecords: [FlossRecord] = [
        
        FlossRecord(date: Calendar.createDate(year: 2024, month: 1, day: 23, hour: 6, minute: 00)),
        FlossRecord(date: Calendar.createDate(year: 2024, month: 1, day: 24, hour: 6, minute: 00)),
        FlossRecord(date: Calendar.createDate(year: 2024, month: 1, day: 25, hour: 6, minute: 00)),
                FlossRecord(date: .now),
        
    ]
    
    var persistance: PersistenceManagerProtocol
    
    init(persistance: PersistenceManagerProtocol = PersistanceManager()) {
        
        self.persistance = persistance
        //        persistance.getFlossRecords { [weak self] records in
        //            self?.flossRecords = records
        //        }
    }
    
    // MARK: Streak status
    
    enum State {
        case noLogsRecorded, positiveStreak, negativeStreak
    }
    
    var streakStatus: State {
        
        if let lastLogDate = flossRecords.last?.date {
            let datesComparison = Calendar.current.compare(lastLogDate, to: Calendar.yesterday, toGranularity: .day)
            
            // if lastLogDate is earlier than yesterday
            if datesComparison == .orderedAscending {

                return .negativeStreak
            } else {
                
                return .positiveStreak
            }
        } else {
            return .noLogsRecorded
        }
    }
    
    // MARK: Streak counting
    
    var streakCount: Int {
        
        switch streakStatus {
            
        case .negativeStreak:
            
            guard let lastLogDate = flossRecords.last?.date else {
                return 100
            }
            guard let daysCountSinceNoLogs = Calendar.current.dateComponents([.day], from: lastLogDate, to: Calendar.yesterday).day else {
                return 101
            }
            
            return daysCountSinceNoLogs
            
        case .positiveStreak:
            
            let newestToOldestFlossRecords = flossRecords.reversed()
            var counting: Int = 0
            var dateBeingChecked: Date = Calendar.today
            
            for (index, log) in newestToOldestFlossRecords.enumerated() {
                
                guard let dayBeforeDateBeingChecked: Date = Calendar.current.date(byAdding: .day, value: -1, to: dateBeingChecked) else {
                    return 0
                }
                
                if index == 0 {
                    
                    if Calendar.current.isDate(log.date, inSameDayAs: dateBeingChecked) {
                        
                        counting += 1
                        dateBeingChecked = dayBeforeDateBeingChecked
                    } else {
                        
                        dateBeingChecked = dayBeforeDateBeingChecked
                        
                        guard let dayBeforeDateBeingChecked: Date = Calendar.current.date(byAdding: .day, value: -1, to: dateBeingChecked) else {
                            return 0
                        }
                        
                        if Calendar.current.isDate(log.date, inSameDayAs: dateBeingChecked) {
                            
                            counting += 1
                            dateBeingChecked = dayBeforeDateBeingChecked
                        }
                    }
                    
                } else if Calendar.current.isDate(log.date, inSameDayAs: dateBeingChecked) {
                    
                    counting += 1
                    dateBeingChecked = dayBeforeDateBeingChecked
                    
                } else {
                    break
                }
            }
            
            return counting
            
        case .noLogsRecorded:
            return 0
        }
    }
    
    // MARK: Has the user logged today?
    
    var userHasLoggedToday: Bool {
        
        guard let lastLogDate = flossRecords.last?.date else {

            return false
        }
        
        if Calendar.current.isDate(lastLogDate, inSameDayAs: Calendar.today) {
            
            return true
        } else {
            
            return false
        }
    }
    
}

extension HomeViewModel: AddLogViewDelegate {
    func addLogRecord(date: Date) {
//        persistance.saveLastFlossDate(date: date)
//        self.loadData()
        isPresentingAddLogSheet = false
        
    }
    
    func plusButtonPressed() {
        isPresentingAddLogSheet = true
    }
}
