//
//  Avatar.swift
//  TheCursedMap
//
//  Created by Emilia Forsheim on 2025-05-27.
//

import Foundation

struct Avatar: Identifiable {
    let id = UUID()
    let imageName: String
    let category: String
    let price: Int
    var isUnlocked: Bool
}
