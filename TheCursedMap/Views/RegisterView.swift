//
//  RegisterView.swift
//  TheCursedMap
//
//  Created by Emilia Forsheim on 2025-05-19.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject private var viewModel = RegisterViewModel()
    @Environment(\.dismiss) var dismiss
    var onLoginSuccess: () -> Void
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(gradient: Gradient(colors: [
                Color("GrayBlack"),
                Color("Gray"),
                Color("GrayBlack")
            ]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                // Logo
                Image("CursedMapLogo")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .padding(.top, -50)
                    .padding(.bottom, -20)
                
                // Title
                Text("Create Account")
                    .font(.largeTitle)
                    .padding(.bottom, 10)
                
                // Error Message
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                }
                
                // Form
                VStack(spacing: 15) {
                    CustomTextField(text: $viewModel.displayName,
                                    placeHolder: "Name",
                                    image: "person")
                    
                    CustomTextField(text: $viewModel.email,
                                    placeHolder: "Email",
                                    image: "envelope")
                    
                    CustomTextField(text: $viewModel.password,
                                    placeHolder: "Password",
                                    image: "lock",
                                    isSecure: true)
                    
                    CustomTextField(text: $viewModel.confirmPassword,
                                    placeHolder: "Confirm Password",
                                    image: "lock",
                                    isSecure: true)
                }
                .padding(.bottom, 30)
                
                // Register Button
                CustomButton(label: viewModel.isLoading ? "Registering..." : "Register") {
                    SoundManager.shared.playSound(named: "click-click")
                    viewModel.register { success in
                        if success {
                            onLoginSuccess()
                        }
                    }
                }
                .disabled(viewModel.isLoading)
                .frame(width: 180)
                .padding(.bottom, 10)

                Spacer()
            }
            .padding(30)
        }
    }
}

#Preview {
    RegisterView(onLoginSuccess: {})
}
