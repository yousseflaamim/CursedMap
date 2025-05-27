//
//  LocationManager.swift
//  TheCursedMap
//
//  Created by Alexander Malmqvist on 2025-05-19.
//

import Foundation
import CoreLocation
import Combine
import MapKit

// ---
// MARK: - Notifikation för Hittad Kista
// ---
// Denna notifikation används för att meddela andra delar av appen (t.ex. GameView)
// när en kista har hittats av LocationManager.
extension Notification.Name {
    static let chestFound = Notification.Name("chestFoundNotification")
}

// ---
// MARK: - LocationManager Class
// ---
final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var userLocation: CLLocationCoordinate2D? // Användarens aktuella koordinater
    
    var activeChests: [Chest] = []

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 5 // Uppdatera plats var 5:e meter för effektivitet och batteritid
    }
    
    // Starta uppdateringar av användarens plats
    func startLocationUpdates() {
        manager.requestWhenInUseAuthorization() // Be om tillstånd när appen används
        manager.startUpdatingLocation()
    }
    
    // Stoppa uppdateringar av användarens plats (bra för batteritid)
    func stopLocationUpdates() {
        manager.stopUpdatingLocation()
    }
    
    // ---
    // MARK: - Injektion av Kistor
    // ---
    func setChests(_ chests: [Chest]) {
        self.activeChests = chests
        print("LocationManager: Mottog \(chests.count) aktiva kistor från GameView.")
    }
    
    // ---
    // MARK: - CLLocationManagerDelegate Metoder
    // ---

    // Anropas när platstillståndet ändras
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("LocationManager: Platstillgång nekad eller begränsad.")
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }

    // Anropas när nya platsdata är tillgängliga
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return } // Få den senaste CLLocation
        
        self.userLocation = latestLocation.coordinate // Uppdatera userLocation som CLLocationCoordinate2D
        
        print("LocationManager: Plats uppdaterad \(latestLocation.coordinate.latitude), \(latestLocation.coordinate.longitude)")
        
        // Kontrollera om användaren är nära några kistor
        checkForNearbyChests(userLocation: latestLocation) // Skicka hela CLLocation till detekteringsfunktionen
    }

    // Anropas om platsuppdateringar misslyckas
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager: Platshanteraren misslyckades med fel: \(error.localizedDescription)")
    }

    // ---
    // MARK: - Kistdetekteringslogik
    // ---

    private func checkForNearbyChests(userLocation: CLLocation) {
        // Loopa igenom alla kistor som GameView har skickat in
        // Vi kontrollerar bara kistor som INTE redan har hittats
        for chest in activeChests where !chest.isFound {
            let chestLocation = CLLocation(latitude: chest.coordinate.latitude, longitude: chest.coordinate.longitude)
            let distance = userLocation.distance(from: chestLocation) // Beräkna avståndet i meter

            let detectionRadius: CLLocationDistance = 200.0 // Definiera hur nära användaren måste vara 

            if distance < detectionRadius {
                print("LocationManager: Kista hittad! Avstånd: \(String(format: "%.2f", distance)) meter till kista: \(chest.name) (ID: \(chest.id))")

                // MARKERA KISTAN SOM HITTAD
                chest.isFound = true

                // Skicka en notifikation. GameView kommer att lyssna på denna notifikation
                NotificationCenter.default.post(name: .chestFound, object: nil, userInfo: ["chestId": chest.id])
            }
        }
    }
}
