//
//  StartView.swift
//  TheCursedMap
//
//  Created by Jeanette Norberg on 2025-05-19.
//

import SwiftUI

enum AppRoute: Hashable {
    case profile
    case treasure
    case map
    case shop
}

struct StartView: View {
    @State var showInfo = false
    @State var showProfile = false
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                // Bakground
                LinearGradient(
                    gradient: Gradient(colors: [Color("GrayBlack"), Color("Gray"), Color("GrayBlack")]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            SoundManager.shared.playButtonSound(named: "click-click")
                            path.append(AppRoute.shop)
                        }) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(gradient: Gradient(colors: [Color("GrayBlack"), Color("Gray")]),
                                                        startPoint: .top,
                                                        endPoint: .bottom)
                                    )
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.black, lineWidth: 0.5)
                                    )
                                Image(systemName: "cart")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color(red: 0.4, green: 0.0, blue: 0.0))
                            }
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 5)
                    }
                    Spacer()
                }

                VStack {
                    // Logo
                    Image("CursedMapLogo")
                        .resizable()
                        .frame(width: 300, height: 300)
                        .padding(.top, 40)
                        .padding(.bottom, -40)

                    Spacer()
                    
                    Button {
                        SoundManager.shared.playButtonSound(named: "click-click")
                        path.append(AppRoute.map)
                    } label: {
                        Text("Start Map")
                            .font(.system(size: 24, weight: .medium, design: .serif))
                            .frame(width: 280, height: 60)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color("GrayBlack"), Color("Gray")]),
                                               startPoint: .top,
                                               endPoint: .bottom)
                            )
                            .foregroundColor(Color(red: 0.6, green: 0.0, blue: 0.0))
                            .cornerRadius(30)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
                    .padding(.bottom)
                    
                    // NavigationLink for TreasureView, comes whit a backbotton
                    Button {
                        SoundManager.shared.playButtonSound(named: "click-click")
                        path.append(AppRoute.treasure)
                    } label: {
                        Text("Your Treasures")
                            .font(.system(size: 24, weight: .medium, design: .serif))
                            .frame(width: 280, height: 60)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color("GrayBlack"), Color("Gray")]),
                                               startPoint: .top,
                                               endPoint: .bottom)
                            )
                            .foregroundColor(Color(red: 0.6, green: 0.0, blue: 0.0))
                            .cornerRadius(30)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
                    .padding(.bottom)

                    Spacer()

                    HStack {
                        // Info-button
                        Button(action: {
                            showInfo = true
                            SoundManager.shared.playButtonSound(named: "click-click")
                        }) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(gradient: Gradient(colors: [Color("GrayBlack"), Color("Gray")]),
                                                       startPoint: .top,
                                                       endPoint: .bottom)
                                    )
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.black, lineWidth: 0.5)
                                    )
                                Image(systemName: "info")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color(red: 0.6, green: 0.0, blue: 0.0))
                            }
                        }

                        Spacer()

                        // profile button
                        Button {
                            SoundManager.shared.playButtonSound(named: "click-click")
                            path.append(AppRoute.profile)
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(gradient: Gradient(colors: [Color("GrayBlack"), Color("Gray")]),
                                                       startPoint: .top,
                                                       endPoint: .bottom)
                                    )
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.black, lineWidth: 0.5)
                                    )
                                Image(systemName: "person")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color(red: 0.6, green: 0.0, blue: 0.0))
                            }
                        }
                    }
                    .padding(.horizontal, 50)
                    .padding(.bottom, 30)
                }.onAppear{
                    SoundManager.shared.playBackGroundSound(named: "backgroundMusic")
                }

                // Popup overlay – Shows upon over all.
                if showInfo {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()

                    VStack(spacing: 20) {
                        Text("INFO")
                            .font(.system(size: 24, weight: .bold, design: .serif))
                            .foregroundColor(Color.black)

                        Text("The Cursed Map är ett mystiskt äventyr där du utforskar förbannade områden, samlar skatter och löser Quiz. Du får själv ge dig ut på en promenad för att hitta skattkistorna, med hjälp av kartan. När du hittat en kista och du löst quizet får du skatten i kistan, men om du inte löser det kan du kanske bli skrämd 👻. Så frågan är VÅGAR DU?!")
                            .font(.system(size: 20, weight: .medium, design: .serif))
                            .foregroundColor(Color.black)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Divider().background(Color.black)

                        Button("OK") {
                            showInfo = false
                            SoundManager.shared.playButtonSound(named: "click-click")
                        }
                        .font(.system(size: 24, weight: .bold, design: .serif))
                        .padding()
                        .foregroundColor(.black)
                        .background(Color(.darkGray))
                        .cornerRadius(10)
                    }
                    .padding()
                    .frame(width: 300)
                    .background(Color(.darkGray))
                    .cornerRadius(16)
                    .shadow(radius: 10)
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                   switch route {
                   case .profile:
                       ProfileView()
                   case .treasure:
                       TreasureView()
                   case.map:
                       GameView()
                   case.shop:
                       ShopView()
                   }
               }
   
        }.tint(.gray)
    }
}

#Preview {
    StartView()
}
