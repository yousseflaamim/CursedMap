//
//  TheCursedMapApp.swift
//  TheCursedMap
//
//  Created by Alexander Malmqvist on 2025-05-14.
//

import SwiftUI
import FirebaseCore
import UserNotifications
import CoreLocation

@main
struct TheCursedMapApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                StartView()
            } else {
                LoginView {
                    isLoggedIn = true
                }.id(UUID())
            }
        }
    }
}

// Firebase App Delegate
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    private var locationManagerForNotifications: LocationManager?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        
        // Sätt delegeringen för User Notifications Center
        UNUserNotificationCenter.current().delegate = self
        
        print("AppDelegate: didFinishLaunchingWithOptions - UNUserNotificationCenter delegate satt.")
        
        // Skapa en instans av LocationManager och schemalägg notisen direkt
        locationManagerForNotifications = LocationManager()
        locationManagerForNotifications?.scheduleDailyReminderNotification()
        
        return true
    }
    
    // MARK: - UNUserNotificationCenterDelegate Methods

    // Denna metod anropas när en notis mottas MEDAN appen är i FÖRGRUNDEN.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("AppDelegate: Notis mottagen i förgrunden: \(notification.request.content.title)")
        completionHandler([.banner, .sound, .badge])
    }

    // Denna metod anropas när användaren interagerar med en notis (t.ex. klickar på den).
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("AppDelegate: Användare interagerade med notis: \(response.notification.request.content.title)")
        
        completionHandler()
    }
}
