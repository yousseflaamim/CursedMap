//
//  User.swift
//  TheCursedMap
//
//  Created by gio on 5/20/25.
//


import Foundation
import FirebaseAuth

import FirebaseAuth

struct User {
    let uid: String
    var displayName: String?
    var email: String?
    var profileImageUrl: String?
    
    init(uid: String, displayName: String?, email: String?, profileImageUrl: String?) {
        self.uid = uid
        self.displayName = displayName
        self.email = email
        self.profileImageUrl = profileImageUrl
    }
    
    init?(from firebaseUser: FirebaseAuth.User) {
        self.uid = firebaseUser.uid
        self.displayName = firebaseUser.displayName
        self.email = firebaseUser.email
        self.profileImageUrl = nil
    }
}
