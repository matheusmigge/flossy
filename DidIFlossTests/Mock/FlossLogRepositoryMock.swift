import Foundation
import Combine
@testable import DidIFloss
import FlossyData

final class FlossLogRepositoryMock: FlossLogRepository, @unchecked Sendable {
    
    var subject = PassthroughSubject<[FlossLog], Never>()
    
    var logsPublisher: AnyPublisher<[FlossLog], Never> {
        subject.eraseToAnyPublisher()
    }
    
    var fetchedLogs: [FlossLog] = []
    
    func fetchLogs() async throws -> [FlossLog] {
        return fetchedLogs
    }
    
    func fetchLogs(on date: Date) async throws -> [FlossLog] {
        return fetchedLogs
    }
    
    var didCallAddLog = false
    func addLog(_ log: FlossLog) async throws {
        didCallAddLog = true
    }
    
    var didCallDeleteLog = false
    func deleteLog(id: String) async throws { didCallDeleteLog = true }
    var didCallDeleteLogs = false
    func deleteLogs(on date: Date) async throws { didCallDeleteLogs = true }
    func deleteAllLogs() async throws {}
}
