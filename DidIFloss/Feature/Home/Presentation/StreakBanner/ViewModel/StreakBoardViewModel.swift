import Foundation
import FlossyCore
import SwiftUI
struct StreakBoardViewModel {
    let streakBoardContent: StreakBoardModel
    let warmingBoardContent: WarningBannerModel
}

extension StreakBoardViewModel {
    init(state: StreakState) {
        switch state {
        case .noHistory:
            self.init(streakBoardContent: .noLogsRecorded, warmingBoardContent: .noLogsRecorded)
        case .startedToday:
            self.init(streakBoardContent: .firstDayOfPositiveStreak, warmingBoardContent: .userHadLoggedToday)
        case .activePendingToday(let days):
            self.init(streakBoardContent: .positiveStreak(count: days), warmingBoardContent: .userHasPositiveStreak)
        case .activeCompletedToday(let days):
            self.init(streakBoardContent: .positiveStreak(count: days), warmingBoardContent: .userHadLoggedToday)
        case .inactive(let days):
            let content: StreakBoardModel = days < 3
            ? .shortNegativeStreak
            : .longNegativeStreak(count: days)
            
            self.init(streakBoardContent: content, warmingBoardContent: .userHasNegativeStreak)
        }
    }
}
