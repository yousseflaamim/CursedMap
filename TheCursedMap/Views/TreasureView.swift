//
//  TreasureView.swift
//  TheCursedMap
//
//  Created by Jeanette Norberg on 2025-05-19.
//

import SwiftUI

struct TreasureView: View {
    
    @StateObject var treasureViewModel = TreasureViewModel()
    
    var body: some View {
        
        // in use of progressView
        let maxCoinsPerLevel = 100
        let progress = min(Double(treasureViewModel.coins % maxCoinsPerLevel) / Double(maxCoinsPerLevel), 1.0)
        
        ZStack{
         Color("GrayBlack")
                .ignoresSafeArea()
            
            VStack{
                HStack{
                    Image("openChest1") // en mindre öppnad kista än den andra som blev förstor
                        .padding()
                    Text("\(treasureViewModel.openedTreasure)")                  .foregroundColor(.gray)
                        .padding()
                    Spacer()
                        Image("coinpile")
                    Text("\(treasureViewModel.coins)")
                        .foregroundColor(.gray)
                        .padding(20)
                }
                HStack{
                    Image("openChest")
                        .padding(.bottom)
                    Text("Your Treasures!")
                        .font(.system(size: 24, weight: .medium, design: .serif))
                        .foregroundColor(Color.red)
                        .padding(.bottom)
                }
                
                Spacer()
                // ProgressView for Level up
                VStack(alignment: .leading) {
                    Text("Level \(treasureViewModel.level)")
                        .foregroundColor(.yellow)
                        .font(.system(size: 18, weight: .medium, design: .serif))

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

#Preview {
    TreasureView()
}
