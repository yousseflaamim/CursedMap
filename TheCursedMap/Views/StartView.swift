//
//  StartView.swift
//  TheCursedMap
//
//  Created by Jeanette Norberg on 2025-05-19.
//

import SwiftUI

struct StartView: View {
    @State var showInfo = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Bakground
                LinearGradient(
                    gradient: Gradient(colors: [Color("GrayBlack"), Color("Gray"), Color("GrayBlack")]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack {
                    // Logo
                    Image("CursedMapLogo")
                        .resizable()
                        .frame(width: 300, height: 300)
                        .padding(.top)
                        .padding(.bottom, -20)

                    Spacer()

                    // Start Map-button
                    Button("Start Map") {
                        // Start Game logic här
                    }
                    .font(.system(size: 24, weight: .medium, design: .serif))
                    .frame(width: 280, height: 60)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color("GrayBlack"), Color("Gray")]),
                                       startPoint: .top,
                                       endPoint: .bottom)
                    )
                    .foregroundColor(.black)
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .padding(.bottom)

                    // NavigationLink for TreasureView, comes whit a backbotton
                    NavigationLink(destination: TreasureView()) {
                        Text("Your Treasures")
                            .font(.system(size: 24, weight: .medium, design: .serif))
                            .frame(width: 280, height: 60)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color("GrayBlack"), Color("Gray")]),
                                               startPoint: .top,
                                               endPoint: .bottom)
                            )
                            .foregroundColor(.black)
                            .cornerRadius(30)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }

                    Spacer()

                    HStack {
                        // Info-button
                        Button(action: {
                            showInfo = true
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
                                    .foregroundColor(.black)
                            }
                        }

                        Spacer()

                        // profile button
                        NavigationLink(destination: ProfileView()) {
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
                                Image(systemName: "gearshape")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .padding(.horizontal, 50)
                    .padding(.bottom, 30)
                }

                // Popup overlay – Shows upon over all.
                if showInfo {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()

                    VStack(spacing: 20) {
                        Text("INFO")
                            .font(.system(size: 24, weight: .bold, design: .serif))

                        Text("The Cursed Map är ett mystiskt äventyr där du utforskar förbannade områden, samlar skatter och löser Quiz. Du får själv ge dig ut på en promenad för att hitta skattkistorna, med hjälp av kartan. När du hittat en kista och du löst quizet får du skatten i kistan, men om du inte löser det kan du kanske bli skrämd 👻. Så frågan är VÅGAR DU?!")
                            .font(.system(size: 20, weight: .medium, design: .serif))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Divider().background(Color.black)

                        Button("OK") {
                            showInfo = false
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
        }
    }
}

#Preview {
    StartView()
}
