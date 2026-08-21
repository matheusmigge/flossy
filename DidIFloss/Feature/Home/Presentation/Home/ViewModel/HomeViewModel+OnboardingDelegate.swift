import Foundation

extension HomeViewModel: OnboardingDelegate {
    func onboardingDidComplete() {
        notificationService?.requestAuthorizationToNotificate(provisional: false)
        coordinatorDelegate?.onboardingDidComplete()
    }
}
