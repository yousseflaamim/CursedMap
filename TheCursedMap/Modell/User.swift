//
//  AppUser.swift
//  TheCursedMap
//
//  Created by gio on 5/20/25.
//


import Foundation

struct User: Identifiable, Codable {
    let id: String
    let email: String
    var displayName: String
    var profileImageUrl: String?
    
}
