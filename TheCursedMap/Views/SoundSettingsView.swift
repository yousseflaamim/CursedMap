//
//  SoundSettingsView.swift
//  TheCursedMap
//
//  Created by Jeanette Norberg on 2025-05-27.
//

import SwiftUI

struct SoundSettingsView: View {
    
    @StateObject private var soundManager = SoundManager.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack{
            // Bakground
            LinearGradient(
                gradient: Gradient(colors: [Color("GrayBlack"),
                    Color("Gray"),Color("GrayBlack")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            VStack{
                Image("soundSettings")
                    .resizable()
                    .frame(width: 300, height: 100)
                    .padding(.top)
                    .padding(.bottom, -20)
              
                Spacer()
                HStack{
                    Text("All sounds On/Off")
                        .font(.system(size: 18, weight: .medium, design: .serif))
                        .foregroundColor(Color.black)
                    Button(action: {
                        soundManager.toggleSound()
                    }) {
                        Image(systemName: soundManager.isSoundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                            .padding()
                    }
                }
                HStack{
                    Text("Backgrounds music On/Off")
                        .font(.system(size: 18, weight: .medium, design: .serif))
                        .foregroundColor(Color.black)
                    Button(action: {
                        soundManager.toggleBackgroundSound()
                    }) {
                        Image(systemName: soundManager.isBackgroundSoundEnabled ? "music.quarternote.3" : "powersleep")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                            .padding()
                    }
                }
                HStack{
                    Text("Button sound On/Off")
                        .font(.system(size: 18, weight: .medium, design: .serif))
                        .foregroundColor(Color.black)
                    Button(action: {
                        soundManager.toggleButtonSound()
                    }) {
                        Image(systemName: soundManager.isButtonSoundEnabled ? "hand.tap" : "powersleep")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                            .padding()
                    }
                }
                HStack{
                    Text("Soundeffects On/Off")
                        .font(.system(size: 18, weight: .medium, design: .serif))
                        .foregroundColor(Color.black)
                    Button(action: {
                        soundManager.toggleEffectSound()
                    }) {
                        Image(systemName: soundManager.isEffectSoundEnabled ? "sparkles" : "powersleep")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black)
                            .padding()
                    }
                    
                }
             
                Spacer()
                Button {
                    SoundManager.shared.playButtonSound(named: "click-click")
                    dismiss()
                } label: {
                    Text("Back to profile")
                        .font(.system(size: 24, weight: .medium, design: .serif))
                        .frame(width: 280, height: 60)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color("GrayBlack"), Color("Gray")]),
                                           startPoint: .top,
                                           endPoint: .bottom)
                        )
                        .foregroundColor(Color(red: 0.8, green: 0.0, blue: 0.0))
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.black, lineWidth: 1)
                        )
                }
                .padding(.bottom)
            }
        }
    }
}

#Preview {
    SoundSettingsView()
}
