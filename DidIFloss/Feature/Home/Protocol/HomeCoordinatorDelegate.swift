import Foundation

@MainActor
protocol HomeCoordinatorDelegate: AnyObject {
    func didTapAddLogButton()
    func didTapShareStreak(streakMessage: String)
    func didTapLogRecords()
    func onboardingDidComplete()
    func addLogDidComplete()
}
