//
//  DidIFlossApp.swift
//  DidIFloss
//
//  Created by Matheus Migge on 27/12/23.
//

import SwiftUI
import Notification

@main
struct DidIFlossApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        NotificationService.current().requestAuthorizationToNotificate(provisional: true)
        return true
    }
}

