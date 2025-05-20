//
//  TreasureView.swift
//  TheCursedMap
//
//  Created by Jeanette Norberg on 2025-05-19.
//

import SwiftUI

struct TreasureView: View {
    var body: some View {
        ZStack{
         Color("GrayBlack")
                .ignoresSafeArea()
            VStack{
                HStack{
                    Image("open-chest1")
                    Text("Your Treasures!")
                        .font(.system(size: 24, weight: .medium, design: .serif))
                        .foregroundColor(Color.white)
                        .padding()
                }
                Spacer()
                
                List{
                    HStack{
                        Image("open-chest1")
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
