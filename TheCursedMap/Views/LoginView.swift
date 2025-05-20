//
//  ContentView.swift
//  TheCursedMap
//
//  Created by Alexander Malmqvist on 2025-05-14.
// hej

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var path = NavigationPath()
    
    var onLoginSuccess: () -> Void
    
    var body: some View {
        NavigationStack(path: $path) {
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
                    
                    VStack(spacing: 16) {
                        Text("Login")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                        
                        if !viewModel.errorMessage.isEmpty {
                            Text(viewModel.errorMessage)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                        
                        CustomTextField(text: $viewModel.email, placeHolder: "Email", image: "envelope")
                        
                        CustomTextField(text: $viewModel.password, placeHolder: "Password", image: "lock", isSecure: true)
                        
                        CustomButton(label: viewModel.isLoading ? "Logging in..." : "Login") {
                            viewModel.login { success in
                                if success {
                                    onLoginSuccess()
                                }
                            }
                        }
                        .disabled(viewModel.isLoading)
                        .frame(width: 180)
                    }
                    .padding()
                    
                    HStack {
                        Divider().frame(height: 1).background(Color.black)
                        Text("Or").padding(.horizontal, 8).foregroundStyle(.white)
                        Divider().frame(height: 1).background(Color.black)
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        CustomButton(label: "Sign up with Email", iconName: "envelope") {
                            path.append(AuthRoute.register)
                        }
                        
                        Button(action: {
                            path.append(AuthRoute.register)
                        }) {
                            Text("Don’t have an account? Sign up")
                                .font(.subheadline)
                                .underline()
                                .foregroundColor(.white)
                                
                        }
                    }
                    .padding(.bottom)
                }
                .padding()
            }
            .navigationDestination(for: AuthRoute.self) { route in
                switch route {
                case .register:
                    RegisterView {
                        onLoginSuccess()
                    }
                }
            }
        }
        .tint(.black)
    }
}

enum AuthRoute: Hashable {
    case register
}

#Preview {
    LoginView(onLoginSuccess: {})
}
