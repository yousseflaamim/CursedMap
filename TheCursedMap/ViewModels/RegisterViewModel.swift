//
//  RegisterViewModel.swift
//  TheCursedMap
//
//  Created by Emilia Forsheim on 2025-05-20.
//

import Foundation
import Combine

class RegisterViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var displayName: String = ""
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var isRegistered: Bool = false

    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol = FirebaseAuthService()) {
        self.authService = authService
    }

    func register(completion: @escaping (Bool) -> Void) {
        guard validateFields() else {
            completion(false)
            return
        }
        isLoading = true
        errorMessage = ""

        authService.register(email: email, password: password, displayName: displayName) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.isRegistered = true
                    completion(true)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(false)
                }
            }
        }
    }


    private func validateFields() -> Bool {
        if email.isEmpty || password.isEmpty || confirmPassword.isEmpty || displayName.isEmpty {
            errorMessage = "Please fill in all fields"
            return false
        }
        if password != confirmPassword {
            errorMessage = "The passwords do not match"
            return false
        }
        if !email.contains("@") {
            errorMessage = "Invalid email"
            return false
        }
        return true
    }
}
