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
                    
                    VStack {
                        
                        Text("Login")
                            .font(.largeTitle)
                        
                        if !viewModel.errorMessage.isEmpty {
                            Text(viewModel.errorMessage)
                                .foregroundStyle(.red)
                        }
                        
                        CustomTextField(text: $viewModel.email, placeHolder: "Email", image: "envelope")
                        
                        CustomTextField(text: $viewModel.password, placeHolder: "Password", image: "lock", isSecure: true)
                            .padding(.bottom)
                        
                        CustomButton(label: "Login") {
                            onLoginSuccess()
//                            viewModel.login { success in
//                                if success {
//                                    onLoginSuccess()
//                                }
//                            }
                        }
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
                        }
                    }
                    .padding()
                    .tint(.black)
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
    }
}

enum AuthRoute: Hashable {
    case register
}

#Preview {
    LoginView(onLoginSuccess: {})
}
