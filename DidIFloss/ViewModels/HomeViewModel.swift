//
//  HomeViewModel.swift
//  DidIFloss
//
//  Created by Matheus Migge on 24/01/24.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published var sheetView: Sheet?
    @Published var showingCelebration: Bool = false
    
    // MARK: Floss records
    
    @Published var flossRecords: [FlossRecord] = [
        
        FlossRecord(date: Calendar.createDate(year: 2024, month: 1, day: 29, hour: 6, minute: 00)),
//        FlossRecord(date: Calendar.createDate(year: 2024, month: 1, day: 30, hour: 6, minute: 00)),
//        FlossRecord(date: Calendar.createDate(year: 2024, month: 1, day: 31, hour: 6, minute: 00)),
//                FlossRecord(date: .now),
        
    ]
    
    var persistence: PersistenceManagerProtocol
    
    init(persistence: PersistenceManagerProtocol = PersistanceManager()) {
        
        self.persistence = persistence
        //        persistence.getFlossRecords { [weak self] records in
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
    
<<<<<<< HEAD
    // MARK: Warning Banner content
    
    var warningBannerContent: WarningBannerModel {
        
        switch streakStatus {
            
        case .noLogsRecorded:
            WarningBannerModel(backgroundColor: .greenyBlue, text: "Seja bem vindo(a) ao Did I Floss! ☀️", textColor: .white)
            
        case .positiveStreak:
            if userHasLoggedToday {
                WarningBannerModel(backgroundColor: .greenyBlue, text: "O de hoje tá pago! 🫡", textColor: .white)
            } else {
                WarningBannerModel(backgroundColor: .lightYellow, text: "Você ainda não usou o fio dental hoje. Cuidado para não perder o seu combo! ⚠️", textColor: .black)
            }
            
        case .negativeStreak:
            WarningBannerModel(backgroundColor: .flamingoPink, text: "Estamos sentindo sua falta! 😭", textColor: .black)
        }
    }
    
    // MARK: Streak Board content
    
    var streakBoardContent: StreakBoardModel {
        switch streakStatus {
        case .noLogsRecorded:
            StreakBoardModel(titleColor: .greenyBlue, titleText: "Comece seu combo hoje!", captionText: "Até quantos dias seguidos você consegue se manter passando o fio dental? 👀")
        case .positiveStreak:
            
            if streakCount == 1 {
                StreakBoardModel(titleColor: .greenyBlue, titleText: "Combo iniciado!", captionText: "Continue passando o fio dental todos os dias para manter o seu combo.")
            } else {
                StreakBoardModel(titleColor: .greenyBlue, titleText: "\(streakCount) dias seguidos!", captionText: "É isso aí! Até quantos dias você consegue manter o combo? 👀")
            }
        case .negativeStreak:
            if streakCount == 1 {
                StreakBoardModel(titleColor: .flamingoPink, titleText: "Combo perdido!", captionText: "Oh não! Você estava indo tão bem... Tem 5 minutinhos para passar o fio dental e recomeçar o seu combo? 👀")
            } else {
                StreakBoardModel(titleColor: .flamingoPink, titleText: "\(streakCount) dias seguidos!", captionText: "Parece que você está acumulando um combo de dias seguidos sem passar o fio dental! 😭 ")
            }
        }
    }
    
=======
    func viewDidApper() {
        // should show onboard?
        if persistence.checkIfIsNewUser() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.sheetView = .addLogSheet
            }
        }
    }
>>>>>>> main
}

extension HomeViewModel: AddLogViewDelegate {
    func addLogRecord(date: Date) {
//        persistance.saveLastFlossDate(date: date)
//        self.loadData()
        sheetView = nil
        showingCelebration = true
        
    }
    
    func plusButtonPressed() {
        sheetView = .addLogSheet
    }
}

extension HomeViewModel: CelebrationViewDelegate {
    func didCompleteAnimation() {
        withAnimation {
            showingCelebration = false
        }
    }
}

extension HomeViewModel {
    enum Sheet: String, Identifiable {
        case welcomeSheet, addLogSheet
        
        var id: String {
            self.rawValue
        }
    }
}
