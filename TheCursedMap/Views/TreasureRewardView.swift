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
                
                if let name = treasureVM.lastUnlockedCollectibleName { // to show collectble when levelup
                    Text("Level up! ✨ ")
                        .font(.system(size: 24, weight: .medium, design: .serif))
                        .foregroundColor(.yellow)
                        .padding(.top, 20)
                    Text("Du fick: \(name) till din collection!")
                        .font(.system(size: 18, weight: .medium, design: .serif))
                        .foregroundColor(.yellow)
                        .padding(.top, 10)
                }
                
                if let leveledItem = treasureVM.lastLeveledUpCollectible { // to show collectebles levelUp if it leveled up
                    Text("\(leveledItem.name) har nått level \(leveledItem.level)!")
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                        .padding(.top, 12)

                    Text("För att nå nästa nivå: \(leveledItem.requiredCount) st!")
                        .font(.system(size: 16, weight: .medium, design: .serif))
                        .foregroundColor(.yellow)
                        .padding(.top, 4)
                }
            }
        }
        .onAppear {
            SoundManager.shared.playEffectSound(named: "coin-spill")
            
            // Stäng popupen automatiskt efter en kort stund (t.ex. 5 sekunder)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                treasureVM.levelUpReward = 0
                treasureVM.lastUnlockedCollectibleName = nil
                dismissAction()
            }
        }
    }
}

#Preview {
    TreasureRewardView(dismissAction: {})
        .environmentObject(TreasureViewModel())
}
