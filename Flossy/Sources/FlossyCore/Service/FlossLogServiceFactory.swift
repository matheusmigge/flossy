import Foundation
import FlossyData
import FlossyReminders

public enum FlossLogServiceFactory {
    public static func make() -> any FlossLogServicing {
        FlossLogService()
    }
}
