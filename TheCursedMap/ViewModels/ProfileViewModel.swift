//
//  ProfileViewModel.swift
//  TheCursedMap
//
//  Created by Jeanette Norberg on 2025-05-20.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var errorMessage: String = ""
    
    init(){
        fetchUserData()
    }
    
    func fetchUserData(){
        
        guard let userID = Auth.auth().currentUser?.uid else {
            self.errorMessage = "Ingen användare inloggad."
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { snapshot, error in
            DispatchQueue.main.async{
                if let data = snapshot?.data(){
                    self.name = data["name"] as? String ?? "name not found"
                    self.email = data["email"] as? String ?? "email not found"
                }else if let error = error {
                    self.errorMessage = error.localizedDescription
                }
            }
            
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            print("User is signed out.")
        } catch {
            self.errorMessage = "Failed to sign out: \(error.localizedDescription)"
        }
    }
    
    func deleteAccount(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "NoUser", code: 1)))
            return
        }

        user.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
}
