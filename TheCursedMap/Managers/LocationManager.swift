//
//  LocationManager.swift
//  TheCursedMap
//
//  Created by Alexander Malmqvist on 2025-05-19.
//

import Foundation
import CoreLocation
import UserNotifications
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
       
        
        // Be om notisbehörighet direkt vid initiering
        requestNotificationPermission()
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

            let detectionRadius: CLLocationDistance = 15.0 // Definiera hur nära användaren måste vara

            if distance < detectionRadius {
                print("LocationManager: Kista hittad! Avstånd: \(String(format: "%.2f", distance)) meter till kista: \(chest.name) (ID: \(chest.id))")

                // MARKERA KISTAN SOM HITTAD
                chest.isFound = true

                // Skicka en notifikation. GameView kommer att lyssna på denna notifikation
                NotificationCenter.default.post(name: .chestFound, object: nil, userInfo: ["chestId": chest.id])
            }
        }
    }
    
    // ---
    // MARK: - Notishantering
    // ---

    // Metod för att be om notisbehörighet
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notisbehörighet beviljad.")
            } else if let error = error {
                print("Fel vid begäran om notisbehörighet: \(error.localizedDescription)")
            } else {
                print("Notisbehörighet nekad.")
            }
        }
    }

    // Funktion för påminnelsenotis
    func scheduleDailyReminderNotification() {
        // Kontrollera om notisbehörighet är beviljad först
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestNotificationPermission() // Försöker begära behörighet igen
                print("Notisbehörighet: Inte bestämd än. Försöker begära igen.")
                return // Avbryt schemaläggning tills behörighet är satt
            case .denied:
                print("Notisbehörighet: NEKAD av användaren. Notiser kommer inte att visas.")
                return // Avbryt schemaläggning
            case .authorized:
                print("Notisbehörighet: BEVILJAD. Fortsätter med schemaläggning.")
            case .provisional, .ephemeral:
                print("Notisbehörighet: Temporär/Effemär. Fortsätter med schemaläggning.")
            @unknown default:
                print("Notisbehörighet: Okänd status.")
                return
            }

            // --- Notis 1: Efter 3 sekunder ---
            let identifier1 = "firstChestReminder"
            // Ta bort eventuella tidigare schemalagda/levererade notiser med denna identifierare
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier1])
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier1])

            let content1 = UNMutableNotificationContent()
            content1.title = "Kistorna väntar!"
            content1.body = "Öppna din kista idag och hitta nya skatter!"
            content1.sound = UNNotificationSound.default

            let trigger1 = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
            let request1 = UNNotificationRequest(identifier: identifier1, content: content1, trigger: trigger1)

            UNUserNotificationCenter.current().add(request1) { error in
                if let error = error {
                    print("FEL: Kunde INTE schemalägga första notisen: \(error.localizedDescription)")
                } else {
                    print("SUCCESS: Första notisen schemalagd om 3 sekunder.")
                }
            }

            // --- Notis 2: Efter 30 sekunder ---
            let identifier2 = "secondChestReminder"
            // Ta bort eventuella tidigare schemalagda/levererade notiser med denna identifierare
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier2])
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier2])

            let content2 = UNMutableNotificationContent()
            content2.title = "Har du glömt en skattkista?"
            content2.body = "Skynda dig, din skatt väntar inte för evigt!"
            content2.sound = UNNotificationSound.default // Standardljud för notisen

            let trigger2 = UNTimeIntervalNotificationTrigger(timeInterval: 30, repeats: false) // Denna notis kommer efter totalt 30 sekunder

            let request2 = UNNotificationRequest(identifier: identifier2, content: content2, trigger: trigger2)

            UNUserNotificationCenter.current().add(request2) { error in
                if let error = error {
                    print("FEL: Kunde INTE schemalägga andra notisen: \(error.localizedDescription)")
                } else {
                    print("SUCCESS: Andra notisen schemalagd om 30 sekunder.")
                }
            }
        }
    }

    // Funktion för att avbryta en specifik notis 
    func cancelDailyReminderNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyChestReminder"])
        print("Daglig påminnelsenotis avbruten.")
    }
}
