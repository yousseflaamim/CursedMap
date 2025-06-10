//
//  AuthServiceProtocol.swift
//  TheCursedMap
//
//  Created by gio on 5/20/25.
//


import Foundation
import UIKit

protocol AuthServiceProtocol {
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func register(email: String, password: String, displayName: String, completion: @escaping (Result<User, Error>) -> Void)
    func updateDisplayName(_ name: String, completion: @escaping (Result<Void, Error>) -> Void)
    func uploadProfileImage(_ imageData: Data, completion: @escaping (Result<String, Error>) -> Void)
    func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void)
    func logout()
    func currentUser() -> User?
    func deleteAccount(completion: @escaping (Result<Bool, Error>) -> Void)
    func loginWithGoogle(presenting viewController: UIViewController, completion: @escaping (Result<User, Error>) -> Void)

}

