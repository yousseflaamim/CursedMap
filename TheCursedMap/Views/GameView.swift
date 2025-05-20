//
//  GameView.swift
//  TheCursedMap
//
//  Created by Alexander Malmqvist on 2025-05-19.
//

import SwiftUI
import MapKit

struct GameView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, showsUserLocation: true)
                .edgesIgnoringSafeArea(.all)
            
            if locationManager.userLocation == nil {
                ProgressView("Loading map...")
            }
        }
        .onAppear {
            locationManager.startLocationUpdates()
        }
        .onReceive(locationManager.$userLocation) { location in
            if let location = location {
                region = MKCoordinateRegion(
                    center: location,
                    span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                )
            }
        }
    }
}
