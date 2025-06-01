//
//  TreasureRewardView.swift
//  TheCursedMap
//
//  Created by Saeid Ahmadi on 2025-05-28.
//

import SwiftUI
import AVFoundation

struct TreasureRewardView: View {
    let dismissAction: () -> Void
    @State private var player: AVAudioPlayer? // För ljud
    
    @EnvironmentObject var treasureVM: TreasureViewModel

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color("GrayBlack"), Color.yellow.opacity(0.4), Color("GrayBlack")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                Image("openChest1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 20)
                    .shadow(color: .yellow.opacity(0.7), radius: 15, x: 0, y: 0) // Liten glöd

                Text("SKATT HITTAD!")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)

                Text("Totalt: \(treasureVM.openedTreasure) kistor och \(treasureVM.coins) mynt!")
                    .font(.title2)
                    .foregroundColor(.yellow)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .onAppear {
            playSound(named: "coin-spill")
            
            // Stäng popupen automatiskt efter en kort stund (t.ex. 5 sekunder)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                dismissAction()
            }
        }
    }

    // Funktion för att spela upp ljud
    private func playSound(named soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
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
        .environmentObject(TreasureViewModel())
}
