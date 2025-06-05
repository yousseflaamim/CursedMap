//
//  FirebaseAuthService.swift
//  TheCursedMap
//
//  Created by gio on 5/20/25.
//


import Foundation
import FirebaseAuth
import FirebaseStorage
import GoogleSignIn
import FirebaseCore


class FirebaseAuthService: AuthServiceProtocol {
    
    // MARK: - Login
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let firebaseUser = result?.user,
                  let user = User(from: firebaseUser) else {
                completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User conversion failed."])))
                return
            }
            
            completion(.success(user))
        }
    }
    // MARK: - Login with Google
       func loginWithGoogle(presenting viewController: UIViewController, completion: @escaping (Result<User, Error>) -> Void) {
           // 1. الحصول على clientID من Firebase config
           guard let clientID = FirebaseApp.app()?.options.clientID else {
               completion(.failure(NSError(domain: "GoogleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing Client ID"])))
               return
           }

           // 2. إعداد config لجوجل
           let config = GIDConfiguration(clientID: clientID)

           GIDSignIn.sharedInstance.configuration = config

           // 3. بدء عملية تسجيل الدخول
           GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
               if let error = error {
                   completion(.failure(error))
                   return
               }

               guard let user = result?.user,
                     let idToken = user.idToken?.tokenString else {
                   completion(.failure(NSError(domain: "GoogleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Google Sign-In data missing idToken."])))
                   return
               }

               // accessToken.tokenString ليس optional لذلك لا نستخدم guard let
               let accessToken = user.accessToken.tokenString

               // 4. إنشاء credential لـ Firebase
               let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

               // 5. تسجيل الدخول في Firebase باستخدام credential
               Auth.auth().signIn(with: credential) { authResult, error in
                   if let error = error {
                       completion(.failure(error))
                       return
                   }

                   guard let firebaseUser = authResult?.user,
                         let appUser = User(from: firebaseUser) else {
                       completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User conversion failed."])))
                       return
                   }

                   completion(.success(appUser))
               }
           }
       }
    
    // MARK: - Register
    func register(email: String, password: String, displayName: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user else {
                completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User creation failed."])))
                return
            }
            
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = displayName
            changeRequest.commitChanges { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let newUser = User(from: user) else {
                    completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User conversion failed."])))
                    return
                }
                
                completion(.success(newUser))
            }
        }
    }
    
    // MARK: - Logout
    func logout() {
        try? Auth.auth().signOut()
    }
    
    // MARK: - Get Current User
    func currentUser() -> User? {
        guard let firebaseUser = Auth.auth().currentUser else { return nil }
        return User(from: firebaseUser)
    }
    
    
    // MARK: - Update Display Name
    func updateDisplayName(_ name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in."])))
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
    
    // MARK: rest password
    func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    // MARK: - Delete Account
    func deleteAccount(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user is currently logged in."])))
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


    
    // MARK: - Upload Profile Image
    func uploadProfileImage(_ imageData: Data, completion: @escaping (Result<String, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in."])))
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
