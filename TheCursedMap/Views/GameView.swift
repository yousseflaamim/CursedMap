//
//  GameView.swift
//  TheCursedMap
//
//  Created by Alexander Malmqvist on 2025-05-19.
//

import SwiftUI
import MapKit

import SwiftUI
import MapKit

struct Chest: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct GameView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    
    @State private var chests: [Chest] = []
    @State private var chestsGenerated = false

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region,interactionModes: .all, showsUserLocation: true, annotationItems: chests) { chest in
                MapAnnotation(coordinate: chest.coordinate) {
                    Image("closed-chest")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.brown)
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            if locationManager.userLocation == nil {
                ProgressView("Loading map...")
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
            }
        }
    }
    
    private func generateChests(around location: CLLocationCoordinate2D) {
        chests = (0..<10).map { _ in
            let randomLat = location.latitude  + Double.random(in: -0.010...0.010)
            let randomLon = location.longitude + Double.random(in: -0.010...0.010)
            return Chest(coordinate: CLLocationCoordinate2D(latitude: randomLat, longitude: randomLon))
        }
    }
}
