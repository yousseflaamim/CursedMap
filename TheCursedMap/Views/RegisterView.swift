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
            LinearGradient(gradient: Gradient(colors: [Color("GrayBlack"),
                                                       Color("Gray"),
                                                       Color("GrayBlack")]),
                           startPoint: .top,
                           endPoint: .bottom)
            .ignoresSafeArea()
            VStack {
                Image("CursedMapLogo")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .padding(.top, -100)
                    .padding(.bottom, -20)
                VStack {
                    Text("Create Account")
                        .font(.largeTitle)
                }
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundStyle(.red)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                }
                
                VStack {
                    CustomTextField(text: $viewModel.name, placeHolder: "Name", image: "person")
                    
                    CustomTextField(text: $viewModel.email, placeHolder: "Email", image: "envelope")
                    
                    CustomTextField(text: $viewModel.password, placeHolder: "Password", image: "lock", isSecure: true)
                    
                    CustomTextField(text: $viewModel.confirmPassword, placeHolder: "Confirm Password", image: "lock", isSecure: true)
                        .padding(.bottom, 30)
                    
                    CustomButton(label: "Register") {
                        viewModel.register { success in
                            if success {
                                onLoginSuccess()
                            }
                        }
                    }
                }
                .padding(30)
            }
        }
    }
}

#Preview {
    RegisterView(onLoginSuccess: {})
}
