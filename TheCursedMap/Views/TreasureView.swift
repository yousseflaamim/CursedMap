//
//  TreasureView.swift
//  TheCursedMap
//
//  Created by Jeanette Norberg on 2025-05-19.
//

import SwiftUI
import AVKit

struct TreasureView: View {
    
    @StateObject var treasureViewModel = TreasureViewModel()
  
    var body: some View {
        
        // in use of progressView
        let maxXpPerLevel = 150
        let progress = min(Double(treasureViewModel.xp % maxXpPerLevel) / Double(maxXpPerLevel), 1.0)
        
        ZStack{
            Color("GrayBlack")
                .ignoresSafeArea()
           
            
            VStack{
                HStack{
                    Image("openChest1") // en mindre öppnad kista än den andra som blev förstor
                    Text("\(treasureViewModel.openedTreasure)")
                        .font(.system(size: 22, weight: .medium, design: .serif))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    Image("coinpile")
                    Text("\(treasureViewModel.coins)")
                        .foregroundColor(.gray)
                        .font(.system(size: 22, weight: .medium, design: .serif))
                    
                }
                .padding(.horizontal)
                VStack{
                    Image("yourTreasures")
                        .resizable()
                        .frame(width: 300, height: 100)
                        .padding(.top)
                        .padding(.bottom, -20)
                    Image("openChest")
                }
                
                Spacer()
                // ProgressView for Level up
                VStack(alignment: .leading) {
                    HStack{
                        Text("Level: \(treasureViewModel.level)")
                            .foregroundColor(.yellow)
                            .font(.system(size: 18, weight: .medium, design: .serif))
                        Spacer()
                        Text("XP: \(treasureViewModel.xp)")
                            .foregroundColor(.yellow)
                            .font(.system(size: 18, weight: .medium, design: .serif))
                    }
                    
                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle())
                        .frame(height: 10)
                        .tint(.yellow)
                    
                }
                .padding([.leading, .trailing, .bottom])
            
                Spacer()
           
                List{
                    HStack{
                        Image("openChest")
                        Text("Första kistan öpnnad nära göta ....")
                            .font(.system(size: 16, weight: .medium, design: .serif))
                    }
                    .listRowBackground(Color.gray)
                    .padding()
                    
                }
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color("GrayBlack"),Color("Gray"), Color("GrayBlack")]),
                                   startPoint: .top,
                                   endPoint: .bottom)
                )
                .scrollContentBackground(.hidden)
                
                }
           
           
            }
        
        }
    }
/*#Preview {
    TreasureView()
}*/
