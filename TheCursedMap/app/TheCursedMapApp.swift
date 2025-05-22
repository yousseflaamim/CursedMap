//
//  TheCursedMapApp.swift
//  TheCursedMap
//
//  Created by Alexander Malmqvist on 2025-05-14.
//

import SwiftUI
import FirebaseCore
import SwiftData 

@main
struct TheCursedMapApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var isLoggedIn = false

    // MARK: - SwiftData ModelContainer Setup
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            QuizQuestion.self
        ])
        // Konfigurera SwiftData för permanent lagring
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])

            // MARK: - Seed Initial Quiz Questions (om databasen är tom)
            // Denna kod körs bara om databasen är tom när appen startar FÖRSTA gången.
            let quizDescriptor = FetchDescriptor<QuizQuestion>()
            let existingQuizQuestions = try container.mainContext.fetch(quizDescriptor)

            if existingQuizQuestions.isEmpty {
                print("App: Seeding initial quiz questions...")
                container.mainContext.insert(QuizQuestion(questionText: "Vilken färg har blodet?", options: ["Grön", "Gul", "Röd", "Blå"], correctAnswerIndex: 2, explanation: "Blod är rött på grund av hemoglobin och järn."))
                container.mainContext.insert(QuizQuestion(questionText: "Vilket organ pumpar blod?", options: ["Levern", "Lungorna", "Hjärtat", "Njuren"], correctAnswerIndex: 2, explanation: "Hjärtat är en muskel som pumpar blod genom kroppen."))
                container.mainContext.insert(QuizQuestion(questionText: "Vad heter den fiktiva karaktären som bor i en kista?", options: ["Drakula", "Frankenstein", "Jack Sparrow", "Spöket Laban"], correctAnswerIndex: 3, explanation: "Spöket Laban är en vänlig karaktär som bor i en linneskåp i ett slott."))
            }
            

            try container.mainContext.save() // Spara alla ändringar från seeding
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

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
        .modelContainer(sharedModelContainer) // Koppla din ModelContainer till WindowGroup
    }
}

// Firebase App Delegate
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
