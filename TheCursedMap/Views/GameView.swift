//
//  GameView.swift
//  TheCursedMap
//
//  Created by Alexander Malmqvist on 2025-05-19.
//
import SwiftUI
import MapKit
import CoreLocation
import SwiftData

enum MapItem: Identifiable {
    case chest(Chest)
    case user(CLLocationCoordinate2D)

    var id: UUID {
        switch self {
        case .chest(let chest): return chest.id
        case .user: return MapItem.userId // Use static UUID
        }
    }

    var coordinate: CLLocationCoordinate2D {
        switch self {
        case .chest(let chest): return chest.coordinate
        case .user(let coord): return coord
        }
    }

    private static let userId = UUID() // only generated once
}

struct GameView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var treasureVM = TreasureViewModel()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    
    @State private var chests: [Chest] = []
    @State private var chestsGenerated = false
    
    @State private var showingQuiz: Bool = false
    @State private var quizQuestionForCurrentChest: QuizQuestion?

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: mapItems) { item in
                MapAnnotation(coordinate: item.coordinate) {
                    switch item {
                    case .chest(let chest):
                        Image(chest.isFound ? "openChest" : "closedChest")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(chest.isFound ? .green : .brown)
                            .scaleEffect(chest.isFound ? 1.2 : 1.0)
                            .animation(.spring(), value: chest.isFound)

                    case .user:
                        Image("1avatar1")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)

            if locationManager.userLocation == nil {
                ProgressView("Laddar karta...")
                    .foregroundColor(.white)
            }
        }
        .onAppear {
            locationManager.startLocationUpdates()
        }
        .onReceive(locationManager.$userLocation) { location in
            guard let location = location else { return }

            region = MKCoordinateRegion(
                center: location,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )

            if !chestsGenerated {
                generateChests(around: location)
                chestsGenerated = true
                locationManager.setChests(chests)
            }
        }
        // Lyssnar efter notiser om hittade kistor från LocationManager
        .onReceive(NotificationCenter.default.publisher(for: .chestFound)) { notification in
            if let chestId = notification.userInfo?["chestId"] as? UUID {
                // Hitta den hittade kistan i vår lista
                if let foundChest = chests.first(where: { $0.id == chestId }) {
                    print("GameView mottog notis om hittad kista: \(foundChest.name)")
                    
                    if let question = foundChest.associatedQuizQuestion {
                        quizQuestionForCurrentChest = question
                        showingQuiz = true // Visa quizzen!
                    } else {
                        print("Fel: Hittad kista (\(foundChest.name)) saknar tilldelad quizfråga.")
                    }
                }
            }
        }
        
        // Presentera QuizView modalt när en kista hittas
        .sheet(isPresented: $showingQuiz) {
            if let question = quizQuestionForCurrentChest {
                QuizView(question: question, treasureVM: treasureVM)
            } else {
                Text("Kunde inte ladda quizfråga.")
            }
        }
    }
    
    private var mapItems: [MapItem] {
        var items = chests.map { MapItem.chest($0) }
        if let userLocation = locationManager.userLocation {
            items.append(.user(userLocation))
        }
        return items
    }

    private func generateChests(around location: CLLocationCoordinate2D) {
        // Hämta en kopia av de fördefinierade frågorna och blanda dem
        var availableQuestions = QuizViewModel.predefinedQuestions.shuffled()

        chests = (0..<5).map { i in
            let randomLat = location.latitude  + Double.random(in: -0.005...0.005)
            let randomLon = location.longitude + Double.random(in: -0.005...0.005)
            
            let questionToAssign = availableQuestions.popLast() // Ta bort sista frågan från listan

            return Chest(coordinate: CLLocationCoordinate2D(latitude: randomLat, longitude: randomLon),
                         name: "Mystisk Kista \(i+1)",
                         associatedQuizQuestion: questionToAssign)
        }
        print("GameView genererade \(chests.count) slumpade kistor med tilldelade frågor.")
    }
}
