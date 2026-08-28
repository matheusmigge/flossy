//
//  HomeViewModel.swift
//  DidIFloss
//
//  Created by Matheus Migge on 24/01/24.
//

import FlossyReminders
import FlossyData
import FlossyStreak
import SwiftUI

import Foundation

import Combine

@MainActor
@Observable
class HomeViewModel: ScreenViewModel {
    
    weak var coordinatorDelegate: HomeCoordinatorDelegate?
    var showingCelebration: Bool = false
    
    var showingAlert: Bool = false
    var focusedDate: Date?
    
    // MARK: Floss records
    
    var flossRecords: [FlossLog] = []
    
    weak var persistence: AppPreferencesProtocol?
    var recordsRepository: any FlossLogRepository
    let notificationService: FlossyRemindersService?
    let addLogRecordUseCase: AddLogRecordUseCaseProtocol
    let streakAnalyzer: any StreakAnalyzer
    
    private var cancellables = Set<AnyCancellable>()
    
    var streakBoardViewModel: StreakBoardViewModel
    
    init(persistence: AppPreferencesProtocol = AppPreferences.shared,
         recordsRepository: any FlossLogRepository = DefaultFlossLogRepositoryFactory.make(),
         notificationService: FlossyRemindersService = FlossyRemindersServiceFactory.make(),
         addLogRecordUseCase: AddLogRecordUseCaseProtocol = AddLogRecordUseCase(),
         streakAnalyzer: any StreakAnalyzer = DefaultStreakAnalyzer()
    ) {
        self.persistence = persistence
        self.recordsRepository = recordsRepository
        self.notificationService = notificationService
        self.addLogRecordUseCase = addLogRecordUseCase
        self.streakAnalyzer = streakAnalyzer
        let initialState = streakAnalyzer.analyze(logDates: [])
        self.streakBoardViewModel = StreakBoardPresenter.makeViewModel(from: initialState)
        
        setupBindings()
    }
    
    private func makeStreakBoardViewModel() -> StreakBoardViewModel {
        let state = streakAnalyzer.analyze(logDates: flossRecords.map({ $0.date }))
        return StreakBoardPresenter.makeViewModel(from: state)
    }
    
    private func setupBindings() {
        recordsRepository.logsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] logs in
                guard let self else { return }
                self.flossRecords = logs
                self.streakBoardViewModel = self.makeStreakBoardViewModel()
            }
            .store(in: &cancellables)
    }
    
    // MARK: Did Appear
    
    func viewDidAppear() async {
        await self.loadData()
    }
    
    func loadData() async {
        guard let records = try? await recordsRepository.fetchLogs() else { return }
        await MainActor.run {
            self.flossRecords = records
            self.streakBoardViewModel = self.makeStreakBoardViewModel()
        }
    }
    

    func plusButtonPressed() {
        if !showingCelebration {
            coordinatorDelegate?.didTapAddLogButton()
        }
    }
    
    func presentShareSheet() {
        let state = streakAnalyzer.analyze(logDates: flossRecords.map{ $0.date })
        let message = ShareStreakMessageFactory.makeMessage(from: state)
        coordinatorDelegate?.didTapShareStreak(streakMessage: message)
    }
    
    func goToLogRecords() {
        coordinatorDelegate?.didTapLogRecords()
    }
    
}


extension HomeViewModel {
    struct StreakBoardPresenter {
        static func makeViewModel(from state: StreakState) -> StreakBoardViewModel {
            switch state {
            case .noHistory:
                return .init(streakBoardContent: .noLogsRecorded, warmingBoardContent: .noLogsRecorded)
            case .startedToday:
                return .init(streakBoardContent: .firstDayOfPositiveStreak, warmingBoardContent: .userHadLoggedToday)
            case .activePendingToday(let days):
                return .init(streakBoardContent: .positiveStreak(count: days), warmingBoardContent: .userHasPositiveStreak)
            case .activeCompletedToday(let days):
                return .init(streakBoardContent: .positiveStreak(count: days), warmingBoardContent: .userHadLoggedToday)
            case .inactive(let days):
                let content: StreakBoardModel = days < 3
                ? .shortNegativeStreak
                : .longNegativeStreak(count: days)
                
                return .init(streakBoardContent: content, warmingBoardContent: .userHasNegativeStreak)
            }
        }
    }
    
    struct ShareStreakMessageFactory {
        static func makeMessage(from state: StreakState) -> String {
            switch state {
            case .noHistory:
                return "I'm starting my flossing streak today!"
            case .startedToday:
                return "Look at me go! I started flossing today!"
            case .activePendingToday(days: let days), .activeCompletedToday(days: let days):
                return "Look at me go! I have been flossing for \(days) days straight!"
            case .inactive(daysSinceLastLog: let days):
                return "Oh no! I need to start flossing again! It's been \(days) days since the last time I've flossed"

            }
        }
    }
}
