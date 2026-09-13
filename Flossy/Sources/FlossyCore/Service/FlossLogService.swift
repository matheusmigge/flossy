import Foundation
import FlossyData
import FlossyReminders

public protocol FlossLogServicing: Sendable {
    func isDateValid(_ date: Date) -> Bool
    func addLogRecord(date: Date) async throws
    func removeLogRecord(_ record: FlossLog) async throws
    func removeLogs(removeAllFor date: Date) async throws
}

public struct FlossLogService: FlossLogServicing, Sendable {
    
    private let addUseCase: AddLogRecordUseCaseProtocol
    private let removeUseCase: RemoveLogRecordUseCaseProtocol
    
    public init(
        recordsRepository: any FlossLogRepository = DefaultFlossLogRepositoryFactory.make(),
        notificationService: FlossyRemindersService = FlossyRemindersServiceFactory.make(),
        streakAnalyzer: any StreakAnalyzer = DefaultStreakAnalyzer()
    ) {
        self.addUseCase = AddLogRecordUseCase(
            recordsRepository: recordsRepository,
            notificationService: notificationService,
            streakAnalyzer: streakAnalyzer
        )
        
        self.removeUseCase = RemoveLogRecordUseCase(
            recordsRepository: recordsRepository,
            notificationService: notificationService
        )
    }
    
    public func isDateValid(_ date: Date) -> Bool {
        addUseCase.isDateValid(date)
    }
    
    public func addLogRecord(date: Date) async throws {
        try await addUseCase.execute(date: date)
    }
    
    public func removeLogRecord(_ record: FlossLog) async throws {
        try await removeUseCase.execute(record: record)
    }
    
    public func removeLogs(removeAllFor date: Date) async throws {
        try await removeUseCase.execute(removeAllFor: date)
    }
}
