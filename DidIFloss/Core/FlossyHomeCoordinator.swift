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
            notificationService: notificationService,
            logInteractionHandler: logInteractionHandler,
            streakAnalyzer: streakAnalyzer
        )
        self.homeViewModel.coordinatorDelegate = self
        
        if persistence.checkIfIsNewUser() {
            let vm = OnboardingViewModel(delegate: self.homeViewModel)
            self.presentingSheet = .welcomeSheet(vm)
        }
    }
    
    enum SheetOption: Identifiable {
        case welcomeSheet(OnboardingViewModel)
        case addLogSheet(AddFlossViewModel)
        case shareStreak(streakInfo: String)
        case developerSheet(DeveloperViewModel)
        
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
        case logRecords(LogRecordsViewModel)
        
        static func == (lhs: NavigationOption, rhs: NavigationOption) -> Bool {
            switch (lhs, rhs) {
            case (.logRecords(let lhsVm), .logRecords(let rhsVm)):
                return lhsVm === rhsVm
            }
        }
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .logRecords(let vm):
                hasher.combine(ObjectIdentifier(vm))
            }
        }
    }
    
    // MARK: - HomeCoordinatorDelegate
    
    func didTapAddLogButton() {
        let vm = AddFlossViewModel(delegate: self.homeViewModel)
        presentingSheet = .addLogSheet(vm)
    }
    
    func didTapShareStreak(streakMessage: String) {
        presentingSheet = .shareStreak(streakInfo: streakMessage)
    }
    
    func didTapLogRecords() {
        let vm = LogRecordsViewModel(
            recordsRepository: self.recordsRepository,
            logRecordsHandler: self.logInteractionHandler
        )
        path.append(NavigationOption.logRecords(vm))
    }
    
    func didTapDeveloperOptions() {
        let vm = DeveloperViewModel()
        presentingSheet = .developerSheet(vm)
    }
    
    func addLogDidComplete() {
        presentingSheet = nil
    }
    
    func onboardingDidComplete() {
        presentingSheet = nil
    }
    
    // MARK: - View Factories
    
    func makeBaseView() -> some View {
        return HomeScreen(viewModel: homeViewModel)
    }
    
    @ViewBuilder
    func makeSheet(for sheetOption: SheetOption) -> some View {
        switch sheetOption {
        case .welcomeSheet(let vm):
            OnboardingScreen(viewModel: vm)
        case .addLogSheet(let vm):
            AddFlossScreen(viewModel: vm)
        case .shareStreak(let message):
            ShareStreakView(streakDescription: message)
                .presentationDetents([.medium])
        case .developerSheet(let vm):
            DeveloperScreen(viewModel: vm)
        }
    }
    
    @ViewBuilder
    func makeView(for navigationOption: NavigationOption) -> some View {
        switch navigationOption {
        case .logRecords(let vm):
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

