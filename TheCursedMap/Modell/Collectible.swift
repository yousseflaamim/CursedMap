//
//  Collectible.swift
//  TheCursedMap
//
//  Created by Jeanette Norberg on 2025-06-02.
//

import Foundation

struct Collectible: Identifiable, Codable, Hashable {
    let id: String
    var name: String
    var imageName: String
    var currentCount: Int
    var requiredCount: Int
    var reward: Int
    var level: Int
}
