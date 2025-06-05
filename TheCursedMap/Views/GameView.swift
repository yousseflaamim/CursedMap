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
    let mapLevel: MapLevel 
    
    @StateObject private var locationManager = LocationManager()
    @StateObject private var treasureVM = TreasureViewModel()
    @StateObject private var avatarManager = AvatarManager()

    
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
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: false, annotationItems: mapItems) { item in
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
                        Image(avatarManager.selectedAvatar)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)

            // Level indicator overlay
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Map Size: \(mapLevel.rawValue)")
                            .font(.system(size: 16, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(10)
                        
                        Text("Chests: \(mapLevel.chestCount)")
                            .font(.system(size: 14, weight: .medium, design: .serif))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(8)
                    }
                    Spacer()
                }
                .padding(.top, 50)
                .padding(.leading, 20)
                Spacer()
            }

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

           
            region.center = location
            
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
                    
                   SoundManager.shared.playEffectSound(named: "openChest") // Play openChest sound before showing quiz
                    if let question = foundChest.associatedQuizQuestion {
                        //DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // wait 1 second then show quiz
                            quizQuestionForCurrentChest = question
                            showingQuiz = true // Visa quizzen!
                       // }
                    } else {
                        print("Fel: Hittad kista (\(foundChest.name)) saknar tilldelad quizfråga.")
                    }
                }
            }
        }
        
        // Presentera QuizView modalt när en kista hittas
        .overlay {
            if showingQuiz, let question = quizQuestionForCurrentChest {
                QuizView(question: question, treasureVM: treasureVM, dismissAction: { showingQuiz = false})
                    .environmentObject(treasureVM)
                    .zIndex(1)
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
        
        // Use level-based chest count and spawn radius
        let chestCount = mapLevel.chestCount
        let spawnRadius = mapLevel.spawnRadius

        chests = (0..<chestCount).map { i in
            let randomLat = location.latitude  + Double.random(in: -spawnRadius...spawnRadius)
            let randomLon = location.longitude + Double.random(in: -spawnRadius...spawnRadius)
            
            let questionToAssign = availableQuestions.popLast() // Ta bort sista frågan från listan

            return Chest(coordinate: CLLocationCoordinate2D(latitude: randomLat, longitude: randomLon),
                         name: "Mystisk Kista \(i+1)",
                         associatedQuizQuestion: questionToAssign)
           
        }
        print("GameView genererade \(chests.count) slumpade kistor för \(mapLevel.rawValue) nivå med tilldelade frågor.")
    }
}
