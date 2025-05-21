//
//  TheCursedMapApp.swift
//  TheCursedMap
//
//  Created by Alexander Malmqvist on 2025-05-14.
//

import SwiftUI
import FirebaseCore

@main
struct TheCursedMapApp: App {
   
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
   // @State private var isLoggedIn = false
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
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
