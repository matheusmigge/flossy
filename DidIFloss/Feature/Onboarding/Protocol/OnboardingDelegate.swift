import Foundation

@MainActor
protocol OnboardingDelegate: AnyObject {
    func onboardingDidComplete()
}
