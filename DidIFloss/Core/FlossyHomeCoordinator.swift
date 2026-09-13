import SwiftUI
import FlossyReminders
import FlossyData
import FlossyCore

@MainActor
@Observable
final class FlossyHomeCoordinator: HomeCoordinatorDelegate {
    
    var path: NavigationPath = .init()
    var presentingSheet: SheetOption?
    
    // MARK: - Dependencies
    private let persistence: AppPreferencesProtocol
    private let recordsRepository: any FlossLogRepository
    private let notificationService: FlossyRemindersService?
    private let streakAnalyzer: any StreakAnalyzer
    private let flossLogService: FlossLogServicing
    
    // Retain view models that act as delegates for sheets
    var homeViewModel: HomeViewModel = HomeViewModel()
    
    init(persistence: AppPreferencesProtocol = AppPreferences.shared,
         recordsRepository: any FlossLogRepository = DefaultFlossLogRepositoryFactory.make(),
         notificationService: FlossyRemindersService = FlossyRemindersServiceFactory.make(),
         streakAnalyzer: any StreakAnalyzer = DefaultStreakAnalyzer(),
         flossLogService: (any FlossLogServicing)? = nil) {
        
        self.persistence = persistence
        self.recordsRepository = recordsRepository
        self.notificationService = notificationService
        self.streakAnalyzer = streakAnalyzer
        self.flossLogService = flossLogService ?? FlossLogServiceFactory.make()
        
        // Inject dependencies into HomeViewModel
        self.homeViewModel = HomeViewModel(
            persistence: persistence,
            recordsRepository: recordsRepository,
            notificationService: notificationService,
            streakAnalyzer: streakAnalyzer,
            flossLogService: self.flossLogService
        )
        self.homeViewModel.coordinatorDelegate = self
        checkForOnboarding()
    }
    
    enum SheetOption: Identifiable {
        case welcomeSheet(OnboardingViewModel)
        case addLogSheet(AddFlossViewModel)
        
        var id: String {
            switch self {
            case .welcomeSheet: return "welcomeSheet"
            case .addLogSheet: return "addLogSheet"
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
    
    func checkForOnboarding() {
        if persistence.checkIfIsNewUser() {
            let vm = OnboardingViewModel(
                notificationService: self.notificationService,
                coordinatorDelegate: self
            )
            self.presentingSheet = .welcomeSheet(vm)
        }
    }
    
    // MARK: - HomeCoordinatorDelegate
    
    func didTapAddLogButton() {
        let vm = AddFlossViewModel(
            flossLogService: self.flossLogService,
            coordinatorDelegate: self
        )
        presentingSheet = .addLogSheet(vm)
    }
    

    
    func didTapLogRecords() {
        let vm = LogRecordsViewModel(
            recordsRepository: self.recordsRepository,
            flossLogService: self.flossLogService
        )
        path.append(NavigationOption.logRecords(vm))
    }
    
    func addLogDidComplete() {
        presentingSheet = nil
        self.homeViewModel.showingCelebration = true
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

