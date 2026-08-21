import Foundation

@MainActor
protocol HomeCoordinatorDelegate: AnyObject {
    func didTapAddLogButton()
    func didTapShareStreak(streakMessage: String)
    func didTapLogRecords()
    func didTapDeveloperOptions()
    func onboardingDidComplete()
    func addLogDidComplete()
}
