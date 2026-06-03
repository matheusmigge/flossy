//
//  PersistenceManager.swift
//  DidIFloss
//
//  Created by Matheus Migge on 27/12/23.
//

import Foundation

/// A class responsible for managing data persistence and user flossing records.
///
/// `PersistenceManager` handles saving, retrieving, and deleting flossing records,
/// as well as updating user preferences using `UserDefaults`. It interacts with
/// a data provider service to fetch or modify the floss records.
class PersistenceManager: PersistenceManagerProtocol {
    
    /// A shared instance of `PersistenceManager` to maintain a single point of persistence management.
    ///
    /// Use the shared instance to ensure consistency across the app.
    public static let shared: PersistenceManager = PersistenceManager(
        userDefaults: UserDefaults.standard,
        flossRecordService: FlossRecordDataSource()
    )
    
    /// The `UserDefaults` interface used to store and retrieve user settings and preferences.
    let userDefaults: UserDefaultable
    
    /// The service responsible for managing floss records.
    let flossRecordService: FlossRecordDataProviderProtocol
    
    /// A delegate to notify about changes in the floss record database.
    weak var delegate: PersistenceDelegate?
    
    /// Initializes a new instance of `PersistenceManager`.
    ///
    /// - Parameters:
    ///   - userDefaults: An object conforming to `UserDefaultable` for storing user preferences.
    ///   - flossRecordService: A service that conforms to `FlossRecordDataProviderProtocol` for fetching and managing floss records.
    ///
    /// **Note:** It's important to use the shared instance to ensure a single instance of the
    /// persistence container for data consistency.
    init(userDefaults: UserDefaultable, flossRecordService: FlossRecordDataProviderProtocol) {
        self.userDefaults = userDefaults
        self.flossRecordService = flossRecordService
    }
    
    /// Retrieves the date of the last flossing event.
    ///
    /// - Returns: The `Date` of the last flossing event, or `nil` if no record exists.
    func getLastFlossDate() -> Date? {
        return userDefaults.value(forKey: UserDefaultsKeys.date) as? Date
    }
    
    /// Updates the last flossing date in `UserDefaults`.
    ///
    /// - Parameter date: The new date to be saved. Pass `nil` to clear the date.
    private func updateLastFlossDate(_ date: Date?) {
        self.userDefaults.set(date, forKey: UserDefaultsKeys.date)
    }
    
    /// Fetches all flossing records asynchronously.
    ///
    /// - Parameter handler: A closure that receives an array of `FlossRecord` objects.
    func getFlossRecords(handler: @escaping ([FlossRecord]) -> Void) {
        flossRecordService.fetchRecords { result in
            switch result {
            case .success(let fetchedRecords):
                handler(fetchedRecords)
            case .failure(let error):
                print("Failed to fetch Records from Service -> Error: \(error)")
                print("Trying to get last data in userDefaults")
                handler([])
            }
        }
    }
    
    /// Deletes a specific floss record and updates the last flossing date if necessary.
    ///
    /// - Parameter record: The `FlossRecord` to be deleted.
    func deleteFlossRecord(_ record: FlossRecord) {
        let lastFlossDate = getLastFlossDate()
        flossRecordService.removeRecord(record)
        
        if record.date == lastFlossDate {
            userDefaults.set(nil, forKey: UserDefaultsKeys.date)
            
            flossRecordService.fetchRecords { [weak self] result in
                let data = try? result.get()
                let previousLog = data?.last
                self?.updateLastFlossDate(previousLog?.date)
            }
        }
        
        delegate?.hadChangesInFlossRecordDataBase()
    }
    
    /// Deletes multiple floss records.
    ///
    /// - Parameter records: An array of `FlossRecord` objects to be deleted.
    func deleteFlossRecords(_ records: [FlossRecord]) {
        records.forEach { record in
            self.deleteFlossRecord(record)
        }
    }
    
    /// Saves a new flossing date and updates the last flossing date if needed.
    ///
    /// - Parameter date: The date of the flossing event to be saved.
    func saveFlossDate(date: Date) {
        if let lastFlossDate = getLastFlossDate() {
            if date > lastFlossDate {
                updateLastFlossDate(date)
            }
        } else {
            updateLastFlossDate(date)
        }
        
        flossRecordService.appendRecord(date)
    }
    
    /// Erases all stored user data, including floss records and preferences.
    func eraseData() {
        userDefaults.set(nil, forKey: UserDefaultsKeys.date)
        userDefaults.set(false, forKey: UserDefaultsKeys.didUserAlreadyUseApp)
        flossRecordService.eraseRecords()
    }
    
    /// Checks if the user is new to the app.
    ///
    /// - Returns: `true` if the user is new, `false` otherwise. If the user is new,
    ///   this method will also update the user state in `UserDefaults`.
    func checkIfIsNewUser() -> Bool {
        let isNewUser = !userDefaults.bool(forKey: UserDefaultsKeys.didUserAlreadyUseApp)
        
        if isNewUser {
            userDefaults.set(true, forKey: UserDefaultsKeys.didUserAlreadyUseApp)
            return true
        } else {
            return false
        }
    }
}
