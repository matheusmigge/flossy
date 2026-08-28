import Foundation

@MainActor
protocol HomeCoordinatorDelegate: AnyObject {
    func didTapAddLogButton()
    func didTapLogRecords()
    func onboardingDidComplete()
    func addLogDidComplete()
}
