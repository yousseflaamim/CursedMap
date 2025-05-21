//
//  Chest.swift
//  TheCursedMap
//
//  Created by Saeid Ahmadi on 2025-05-21.
//

import Foundation
import CoreLocation // För CLLocationCoordinate2D
import Combine // För @Published, då Chest blir en ObservableObject

final class Chest: Identifiable, ObservableObject { // VIKTIGT: final class och ObservableObject
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    @Published var isFound: Bool // Denna status kommer att uppdateras när kistan hittas

    // Lägg till ett namn för utskrifter/debug
    var name: String // Optional, för att ge kistan ett namn för bättre debugging

    init(coordinate: CLLocationCoordinate2D, isFound: Bool = false, name: String = "Okänd Kista") {
        self.coordinate = coordinate
        self.isFound = isFound
        self.name = name
    }
}
