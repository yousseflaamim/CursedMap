//
//  ProfileViewModel.swift
//  TheCursedMap
//
//  Created by Jeanette Norberg on 2025-05-20.
//

import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var errorMessage: String = ""
    
    @Published var newDisplayName: String = ""
    @Published var profileImageData: Data? = nil
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = true

    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol = FirebaseAuthService()) {
        self.authService = authService
        fetchUserData()
    }
    
    func fetchUserData() {
        guard let user = authService.currentUser() else {
            self.errorMessage = "Ingen användare inloggad."
            return
        }
        
        self.name = user.displayName ?? "Namn saknas"
        self.email = user.email ?? "E-post saknas"
        self.newDisplayName = self.name
    }
    
    func signOut() {
        authService.logout()
        isLoggedIn = false
        print("User is signed out.")
    }
    
    func deleteAccount(completion: @escaping (Result<Bool, Error>) -> Void) {
        authService.deleteAccount { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func updateDisplayName(completion: @escaping (Result<Void, Error>) -> Void) {
        authService.updateDisplayName(newDisplayName) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.name = self?.newDisplayName ?? ""
                    completion(.success(()))
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(.failure(error))
                }
            }
        }
    }
    
    func uploadProfileImage(completion: @escaping (Result<String, Error>) -> Void) {
        guard let data = profileImageData else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No image data"])))
            return
        }
        authService.uploadProfileImage(data) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let imageUrl):
                    completion(.success(imageUrl))
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(.failure(error))
                }
            }
        }
    }
}
