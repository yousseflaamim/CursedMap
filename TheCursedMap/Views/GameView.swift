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

struct GameView: View {
    @StateObject private var locationManager = LocationManager()
    
    // Kartans region kommer att uppdateras när userLocation uppdateras
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    
    @State private var chests: [Chest] = [] // Array med de slumpade kistorna 
    @State private var chestsGenerated = false // För att bara generera kistor en gång
    
    @State private var showingQuiz: Bool = false // Kontrollerar visning av quiz
    @State private var currentFoundChestId: UUID? // ID för den kista som triggade quizzen

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: chests) { chest in
                // Visar olika ikon beroende på om kistan är hittad
                MapAnnotation(coordinate: chest.coordinate) {
                    
                    Image(chest.isFound ? "open-chest1" : "closed-chest")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(chest.isFound ? .green : .brown) // Färg för debugging
                        .scaleEffect(chest.isFound ? 1.2 : 1.0)
                        .animation(.spring(), value: chest.isFound)
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
        // Lyssnar på användarens platsuppdateringar från LocationManager
        .onReceive(locationManager.$userLocation) { location in
            guard let location = location else { return }

            // Uppdaterar kartans region till användarens position
            region = MKCoordinateRegion(
                center: location, // Använd CLLocationCoordinate2D direkt här
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )

            // Generera kistor bara en gång när första platsen är känd
            if !chestsGenerated {
                generateChests(around: location) // Skicka CLLocationCoordinate2D
                chestsGenerated = true
                // Ge LocationManager listan med de genererade kistorna
                locationManager.setChests(chests)
            }
        }
        // Lyssnar efter notiser om hittade kistor från LocationManager
        .onReceive(NotificationCenter.default.publisher(for: .chestFound)) { notification in
            if let chestId = notification.userInfo?["chestId"] as? UUID {
                // Denna del är främst för att GameView ska reagera på att quiz ska visas.
                if let foundChest = chests.first(where: { $0.id == chestId }) {
                    print("GameView mottog notis om hittad kista: \(foundChest.name)")
                    currentFoundChestId = chestId // Spara ID om du vill skicka det till quizzen
                    showingQuiz = true // Visa quizzen!
                }
            }
        }
        // Presentera QuizView modalt när en kista hittas
        .sheet(isPresented: $showingQuiz) {
            QuizView()
        }
    }

    private func generateChests(around location: CLLocationCoordinate2D) {
        chests = (0..<5).map { i in // Generera t.ex. 5 kistor
            let randomLat = location.latitude  + Double.random(in: -0.005...0.005) // Mindre område
            let randomLon = location.longitude + Double.random(in: -0.005...0.005) // Mindre område
            // Skapa nya Chest-objekt och lägg till dem i din array
            return Chest(coordinate: CLLocationCoordinate2D(latitude: randomLat, longitude: randomLon), name: "Mystisk Kista \(i+1)")
        }
        print("GameView genererade \(chests.count) slumpade kistor.")
    }
}

#Preview {
    GameView()
        .modelContainer(
            try! ModelContainer(for: QuizQuestion.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        )
}
