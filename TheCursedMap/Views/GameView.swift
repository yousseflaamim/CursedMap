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
    
    var body: some View {
        ZStack {
            if let region = locationManager.region {
                Map(coordinateRegion: Binding(
                    get: { region },
                    set: { locationManager.region = $0 }
                ), showsUserLocation: true)
                .edgesIgnoringSafeArea(.all)
            } else {
                ProgressView("Loading map...")
            }
        }
        .onAppear {
            locationManager.startLocationUpdates()
        }
    }
}
