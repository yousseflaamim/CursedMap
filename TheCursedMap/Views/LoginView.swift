//
//  LoginView.swift
//  TheCursedMap
//
//  Created by Alexander Malmqvist on 2025-05-14.
//

import SwiftUI
import ProgressHUD
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var path = NavigationPath()
    @State private var showVideo = false
    
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
                    
                    // Title and fields
                    VStack {
                        Text("Login")
                            .font(.largeTitle)
                        
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
                            viewModel.login { success in
                                if success {
                                    HUDManager.showSuccess("Welcome")
                                    onLoginSuccess()
                                } else {
                                    HUDManager.showError("Login failed")

                            SoundManager.shared.playButtonSound(named: "click-click")
                            // HUDManager.showLoading("Is logging in...")
                          
                            viewModel.login { success in
                           
                                    if success {
                                        HUDManager.showSuccess("Welcome")
                                        showVideo = true
                                        onLoginSuccess()
                                    } else {
                                        HUDManager.showError("Login failed")
                                    }

                                }
                            }
                        }
                        .disabled(viewModel.isLoading)
                        .frame(width: 180)
                    }
                    .padding(20)
                    
                    // Divider
                    HStack {
                        Divider().frame(height: 1).background(Color.black)
                        Text("Or").padding(.horizontal, 8)
                        Divider().frame(height: 1).background(Color.black)
                    }
                    

                    // Email sign up
                    CustomButton(label: "Sign up with Email", iconName: "envelope") {
                        SoundManager.shared.playSound(named: "click-click")
                        path.append(AuthRoute.register)
                    }
                    
                    // Google Sign In button
                    CustomButton(label: "Continue with Google", iconImage: Image("google_logo")) {
                        SoundManager.shared.playSound(named: "click-click")
                        guard let rootVC = UIApplication.shared.connectedScenes
                            .compactMap({ $0 as? UIWindowScene })
                            .first?.windows
                            .first?.rootViewController else {
                                HUDManager.showError("Unable to access root view controller.")
                                return
                            }
                        
                        viewModel.loginWithGoogle(presenting: rootVC) { success in
                            if success {
                                HUDManager.showSuccess("Welcome with Google")
                                onLoginSuccess()
                            } else {
                                HUDManager.showError("Google login failed")
                            }

                    VStack {
                        CustomButton(label: "Sign up with Email", iconName: "envelope") {
                            path.append(AuthRoute.register)
                            SoundManager.shared.playButtonSound(named: "click-click")

                        }
                    }

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
            

        }.fullScreenCover(isPresented: $showVideo) {
            WelcomeView(show: $showVideo)}

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
