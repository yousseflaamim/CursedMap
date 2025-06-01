//
//  TreasureRewardView.swift
//  TheCursedMap
//
//  Created by Saeid Ahmadi on 2025-05-28.
//

import SwiftUI
import AVFoundation // För att kunna spela upp ljud

struct TreasureRewardView: View {
    let dismissAction: () -> Void
    @State private var player: AVAudioPlayer? // För ljud

    var body: some View {
        ZStack {
            // Bakgrund för belöningsvyn
            LinearGradient(
                gradient: Gradient(colors: [Color("GrayBlack"), Color.yellow.opacity(0.4), Color("GrayBlack")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                // MARK: Din skattbild här
                Image("gold_pile") // Byt ut "gold_pile" mot namnet på din skattbild i Assets!
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 20)
                    .shadow(color: .yellow.opacity(0.7), radius: 15, x: 0, y: 0) // Liten glöd

                Text("Du hittade en skatt!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)

                Text("Grattis, kistan är din!")
                    .font(.title2)
                    .foregroundColor(.yellow)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .onAppear {
            // Spela upp belöningsljud
            playSound(named: "coin_sound") // Byt ut "coin_sound" mot namnet på ditt ljud i Assets!
            
            // Stäng popupen automatiskt efter en kort stund (t.ex. 3 sekunder)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                dismissAction() // Anropa dismissAction för att stänga vyn
            }
        }
    }

    // Funktion för att spela upp ljud
    private func playSound(named soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { // eller "wav"
            print("Kunde inte hitta ljudfilen: \(soundName).mp3")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Kunde inte spela upp ljud: \(error.localizedDescription)")
        }
    }
}

#Preview {
    TreasureRewardView(dismissAction: {})
}
