//
//  FirebaseAuthService.swift
//  TheCursedMap
//
//  Created by gio on 5/20/25.
//


import Foundation
import FirebaseAuth
import FirebaseStorage

class FirebaseAuthService: AuthServiceProtocol {
    func login(email: String, password: String, completion: @escaping (Result< User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                let appUser = User(
                    id: user.uid,
                    email: user.email ?? "",
                    displayName: user.displayName ?? "",
                )
                completion(.success(appUser))
            }
        }
    }

    func register(email: String, password: String, displayName: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = displayName
                changeRequest.commitChanges { _ in
                    let appUser = User(
                        id: user.uid,
                        email: user.email ?? "",
                        displayName: displayName,
                    )
                    completion(.success(appUser))
                }
            }
        }
    }

    func logout() {
        try? Auth.auth().signOut()
    }

    func currentUser() -> User? {
        guard let user = Auth.auth().currentUser else { return nil }
        return User(
            id: user.uid,
            email: user.email ?? "",
            displayName: user.displayName ?? "",
        )
    }
    
    // MARK: - New Methods
    func updateDisplayName(_ name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])))
            return
        }
        
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        changeRequest.commitChanges { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func uploadProfileImage(_ imageData: Data, completion: @escaping (Result<String, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])))
            return
        }
        
        let storageRef = Storage.storage().reference().child("profile_images/\(userId).jpg")
        
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url.absoluteString))
                }
            }
        }
    }
}
