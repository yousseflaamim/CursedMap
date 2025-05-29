//
//  ResetPasswordView.swift
//  TheCursedMap
//
//  Created by gio on 5/29/25.
//


import SwiftUI
import ProgressHUD

struct ResetPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email: String = ""
    @State private var errorMessage: String = ""
    @State private var isLoading = false
    
    let authService: AuthServiceProtocol

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [
                Color("GrayBlack"),
                Color("Gray"),
                Color("GrayBlack")
            ]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Reset Password")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 40)
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                CustomTextField(text: $email, placeHolder: "Enter your email", image: "envelope")
                
                CustomButton(label: isLoading ? "Sending..." : "Send Reset Link") {
                    resetPassword()
                }
                .disabled(isLoading)
                .frame(width: 200)

                Spacer()
            }
            .padding()
        }
        .tint(.black)
    }

    private func resetPassword() {
        guard !email.isEmpty else {
            errorMessage = "Please enter your email."
            return
        }

        isLoading = true
        errorMessage = ""

        authService.resetPassword(email: email) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success:
                    ProgressHUD.succeed("Reset email sent!")
                    dismiss()
                case .failure(let error):
                    ProgressHUD.failed("Error")
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}
