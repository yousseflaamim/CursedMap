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
    @State private var showVideo = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
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
                            SoundManager.shared.playButtonSound(named: "click-click")
                            // HUDManager.showLoading("Is logging in...")
                            
                            viewModel.login { success in
                           
                                    if success {
                                        HUDManager.showSuccess("Welcome")
                                        showVideo = true
                           
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
                            SoundManager.shared.playButtonSound(named: "click-click")
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
            
                // Show WelcomView in 1 second with a boo sound and then loggin.
            .overlay(
                Group {
                    if showVideo {
                        WelcomeView {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                isLoggedIn = true
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.001))
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity)
                        .zIndex(10)
                    }
                }
            )
        }
     
    }
       
}

enum AuthRoute: Hashable {
    case register
    case resetPassword
}

#Preview {
    LoginView(onLoginSuccess: {})
}
