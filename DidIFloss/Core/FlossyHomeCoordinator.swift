import SwiftUI

@MainActor
@Observable
final class FlossyHomeCoordinator: HomeCoordinatorDelegate {
    
    var path: NavigationPath = .init()
    var presentingSheet: SheetOption?
    
    // Retain view models that act as delegates for sheets
    var homeViewModel: HomeViewModel = HomeViewModel()
    
    init() {
        self.homeViewModel.coordinatorDelegate = self
    }
    
    enum SheetOption: Identifiable {
        case welcomeSheet
        case addLogSheet
        case shareStreak(streakInfo: String)
        case developerSheet
        
        var id: String {
            switch self {
            case .welcomeSheet: return "welcomeSheet"
            case .addLogSheet: return "addLogSheet"
            case .shareStreak: return "shareStreak"
            case .developerSheet: return "developerSheet"
            }
        }
    }
    
    enum NavigationOption: Hashable {
        case logRecords
    }
    
    // MARK: - HomeCoordinatorDelegate
    
    func didTapAddLogButton() {
        presentingSheet = .addLogSheet
    }
    
    func didTapShareStreak(streakMessage: String) {
        presentingSheet = .shareStreak(streakInfo: streakMessage)
    }
    
    func didTapLogRecords() {
        path.append(NavigationOption.logRecords)
    }
    
    func didTapDeveloperOptions() {
        presentingSheet = .developerSheet
    }
    
    func addLogDidComplete() {
        presentingSheet = nil
    }
    
    func onboardingDidComplete() {
        presentingSheet = nil
    }
    
    func needsOnboarding() {
        presentingSheet = .welcomeSheet
    }
    
    // MARK: - View Factories
    
    func makeBaseView() -> some View {
        return HomeScreen(viewModel: homeViewModel)
    }
    
    @ViewBuilder
    func makeSheet(for sheetOption: SheetOption) -> some View {
        switch sheetOption {
        case .welcomeSheet:
            OnboardingScreen()
                .onDisappear {
                    self.onboardingDidComplete()
                }
        case .addLogSheet:
            AddFlossScreen(delegate: self.homeViewModel)
        case .shareStreak(let message):
            ShareStreakView(streakDescription: message)
                .presentationDetents([.medium])
        case .developerSheet:
            DeveloperScreen()
        }
    }
    
    @ViewBuilder
    func makeView(for navigationOption: NavigationOption) -> some View {
        switch navigationOption {
        case .logRecords:
            LogRecordsScreen()
        }
    }
}

extension FlossyHomeCoordinator {
    
    static func makeView() -> some Screen {
        FlossyHomeCoordinatorView()
    }
    
    private struct FlossyHomeCoordinatorView: Screen {
        
        @State var coordinator: FlossyHomeCoordinator = .init()
        
        var body: some View {
            NavigationStack(path: $coordinator.path) {
                coordinator.makeBaseView()
                    .sheet(item: $coordinator.presentingSheet) { sheetOption in
                        coordinator.makeSheet(for: sheetOption)
                    }
                    .navigationDestination(for: FlossyHomeCoordinator.NavigationOption.self) { navigationOption in
                        coordinator.makeView(for: navigationOption)
                    }
            }
        }
    }
}

