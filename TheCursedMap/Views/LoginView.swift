//
//  ContentView.swift
//  TheCursedMap
//
//  Created by Alexander Malmqvist on 2025-05-14.
// hej

import SwiftUI
import ProgressHUD

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var path = NavigationPath()
    
    var onLoginSuccess: () -> Void
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                // Background
                LinearGradient(gradient: Gradient(colors: [
                    Color("GrayBlack"),
                    Color("Gray"),
                    Color("GrayBlack")
                ]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                LoadingView(isVisible: $viewModel.isLoading)
                
                VStack {
                    // Logo
                    Image("CursedMapLogo")
                        .resizable()
                        .frame(width: 300, height: 300)
                        .padding(.top, -55)
                        .padding(.bottom, -25)
                    
                    // Title
                    VStack {
                        Text("Login")
                            .font(.largeTitle)
                        
                        // Error message
                        if !viewModel.errorMessage.isEmpty {
                            Text(viewModel.errorMessage)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                        
                        CustomTextField(text: $viewModel.email, placeHolder: "Email", image: "envelope")
                        
                        CustomTextField(text: $viewModel.password, placeHolder: "Password", image: "lock", isSecure: true)
                            .padding(.bottom)
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                path.append(AuthRoute.resetPassword)
                            }) {
                                Text("Forgot Password?")
                                    .font(.footnote)
                                    .foregroundColor(.black)
                                    .bold()
                                    .padding(.bottom, 10)
                            }
                        }

                        
                        CustomButton(label: viewModel.isLoading ? "Logging in..." : "Login") {
                            SoundManager.shared.playSound(named: "click-click")
                            // HUDManager.showLoading("Is logging in...")
                          
                            viewModel.login { success in
                           
                                    if success {
                                        HUDManager.showSuccess("Welcome")
                                        onLoginSuccess()
                                    } else {
                                        HUDManager.showError("Login failed")
                                    }
                                }
                            
                                
                        }
                        .disabled(viewModel.isLoading)
                        .frame(width: 180)
                    }
                    .padding(20)
                    
                    HStack {
                        VStack {
                            Divider()
                                .frame(height: 1)
                                .background(Color.black)
                        }
                                            
                        Text("Or")
                            .padding(.horizontal, 8)
                                            
                        VStack {
                            Divider()
                                .frame(height: 1)
                                .background(Color.black)
                        }
                    }
                    
                    VStack {
                        CustomButton(label: "Sign up with Email", iconName: "envelope") {
                            path.append(AuthRoute.register)
                            SoundManager.shared.playSound(named: "click-click")
                        }
                    }
                    .padding()
                }
                .padding()
            }
            .navigationDestination(for: AuthRoute.self) { route in
                switch route {
                case .register:
                    RegisterView {
                        onLoginSuccess()
                    }
                case .resetPassword:
                    ResetPasswordView(authService: FirebaseAuthService())
                }
            }

        }
        .tint(.black)
    }
}

enum AuthRoute: Hashable {
    case register
    case resetPassword
}

#Preview {
    LoginView(onLoginSuccess: {})
}
