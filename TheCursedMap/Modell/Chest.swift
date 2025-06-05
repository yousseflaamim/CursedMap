//
//  Chest.swift
//  TheCursedMap
//
//  Created by Saeid Ahmadi on 2025-05-21.
//

import Foundation
import CoreLocation
import Combine

final class Chest: Identifiable, ObservableObject {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    @Published var isFound: Bool // Denna status kommer att uppdateras när kistan hittas

    var name: String
    var associatedQuizQuestion: QuizQuestion? // Denna kommer att sättas när kistan genereras

    init(coordinate: CLLocationCoordinate2D, isFound: Bool = false, name: String = "Okänd Kista", associatedQuizQuestion: QuizQuestion? = nil) {
        self.coordinate = coordinate
        self.isFound = isFound
        self.name = name
        self.associatedQuizQuestion = associatedQuizQuestion
    }
}
