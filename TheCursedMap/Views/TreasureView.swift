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
            Color(red: 120/550, green: 120/550, blue: 120/550)
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
                    }
                }
                .listRowBackground(Color(red: 120/255, green: 120/255, blue: 120/255))
                .background(Color(red: 120/550, green: 120/550, blue: 120/550))
                .scrollContentBackground(.hidden)
              
            }
        }
    }
}

#Preview {
    TreasureView()
}
