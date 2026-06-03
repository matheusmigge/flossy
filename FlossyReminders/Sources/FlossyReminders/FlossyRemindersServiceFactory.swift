//
//  FlossyRemindersServiceFactory.swift
//  FlossyReminders
//
//  Created by Lucas Migge on 03/06/26.
//

import FlossyRemindersCore

public protocol FlossyRemindersService: FlossRemindersServicing {
    
}

extension NotificationService: FlossyRemindersService {
    
}

public enum FlossyRemindersServiceFactory {
    public static func make() -> any FlossyRemindersService {
        NotificationService()
    }
}
