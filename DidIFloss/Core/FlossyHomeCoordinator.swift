import SwiftUI
import FlossyReminders
import FlossyData
import FlossyStreak

@MainActor
@Observable
final class FlossyHomeCoordinator: HomeCoordinatorDelegate {
    
    var path: NavigationPath = .init()
    var presentingSheet: SheetOption?
    
    // MARK: - Dependencies
    private let persistence: AppPreferencesProtocol
    private let recordsRepository: any FlossLogRepository
    private let notificationService: FlossyRemindersService?
    private let logInteractionHandler: HandleLogInteractionUseCaseProtocol
    private let streakAnalyzer: any StreakAnalyzer
    
    // Retain view models that act as delegates for sheets
    var homeViewModel: HomeViewModel = HomeViewModel()
    
    init(persistence: AppPreferencesProtocol = AppPreferences.shared,
         recordsRepository: any FlossLogRepository = DefaultFlossLogRepositoryFactory.make(),
         notificationService: FlossyRemindersService = FlossyRemindersServiceFactory.make(),
         logInteractionHandler: HandleLogInteractionUseCaseProtocol = HandleLogInteractionUseCase(),
         streakAnalyzer: any StreakAnalyzer = DefaultStreakAnalyzer()) {
         
        self.persistence = persistence
        self.recordsRepository = recordsRepository
        self.notificationService = notificationService
        self.logInteractionHandler = logInteractionHandler
        self.streakAnalyzer = streakAnalyzer
        
        // Inject dependencies into HomeViewModel
        self.homeViewModel = HomeViewModel(
            persistence: persistence,
            recordsRepository: recordsRepository,
            notificationService: notificationService ?? FlossyRemindersServiceFactory.make(),
            logInteractionHandler: logInteractionHandler,
            streakAnalyzer: streakAnalyzer
        )
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
            let vm = AddFlossViewModel(delegate: self.homeViewModel)
            AddFlossScreen(viewModel: vm)
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
            let vm = LogRecordsViewModel(
                recordsRepository: self.recordsRepository,
                logRecordsHandler: self.logInteractionHandler
            )
            LogRecordsScreen(viewModel: vm)
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

