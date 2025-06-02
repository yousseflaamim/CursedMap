//
//  TheCursedMapApp.swift
//  TheCursedMap
//
//  Created by Alexander Malmqvist on 2025-05-14.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn


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
                }
            }
        }
    }
}

// Firebase App Delegate
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    //fun login with google
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
}

