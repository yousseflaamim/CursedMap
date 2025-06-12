//
//  LoginViewModel.swift
//  TheCursedMap
//
//  Created by Emilia Forsheim on 2025-05-19.
//

import Foundation
import Combine
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage = ""
    @Published var isLoading: Bool = false
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    private let authService: AuthServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(authService: AuthServiceProtocol = FirebaseAuthService()) {
        self.authService = authService
    }

    func login(completion: @escaping (Bool) -> Void) {
        guard validateFields() else {
            completion(false)
            return
        }
        isLoading = true
        errorMessage = ""

        authService.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                   // self?.isLoggedIn = true // kan inte vara här utan flyttad till LoginView för att kunna visa welcomeView
                    completion(true)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(false)
                }
            }
        }
    }

    private func validateFields() -> Bool {
        if email.trimmingCharacters(in: .whitespaces).isEmpty || password.isEmpty {
            errorMessage = "Please enter your email and password"
            return false
        }
        if !email.contains("@") {
            errorMessage = "Invalid email"
            return false
        }
        return true
    }
    //loginwithgoogle
      
      func loginWithGoogle(presenting viewController: UIViewController, completion: @escaping (Bool) -> Void) {
          isLoading = true
          authService.loginWithGoogle(presenting: viewController) { [weak self] result in
              DispatchQueue.main.async {
                  self?.isLoading = false
                  switch result {
                  case .success:
                      self?.isLoggedIn = true
                      completion(true)
                  case .failure(let error):
                      self?.errorMessage = error.localizedDescription
                      completion(false)
                  }
              }
          }
      }
    
    //restpassword
    func resetPassword(completion: @escaping (Bool, String?) -> Void) {
        guard !email.isEmpty else {
            completion(false, "Please enter your email")
            return
        }
        authService.resetPassword(email: email) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(true, nil)
                case .failure(let error):
                    completion(false, error.localizedDescription)
                }
            }
        }
    }
}
