//
//  User.swift
//  TheCursedMap
//
//  Created by gio on 5/20/25.
//


import Foundation
import FirebaseAuth

struct User: Identifiable, Codable {
    let id: String
    let email: String
    var displayName: String
    var profileImageUrl: String?
    
    init(id: String, email: String, displayName: String, profileImageUrl: String? = nil) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.profileImageUrl = profileImageUrl
    }

    init?(from firebaseUser: FirebaseAuth.User) {
        guard let email = firebaseUser.email else { return nil }
        self.id = firebaseUser.uid
        self.email = email
        self.displayName = firebaseUser.displayName ?? ""
        self.profileImageUrl = firebaseUser.photoURL?.absoluteString
    }
}
