//
//  LoadingView.swift
//  TheCursedMap
//
//  Created by Jeanette Norberg on 2025-06-02.
//

import SwiftUI

struct LoadingView: View {
    @Binding var isVisible: Bool
        @State private var rotation: Double = 0

        var body: some View {
            if isVisible {
                ZStack {
                   // Color.black.opacity(0.7).ignoresSafeArea()
                   
                    VStack(spacing: 16) {
                        
                        Image("pirate")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .rotationEffect(.degrees(rotation))
                            .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false), value: rotation)
                            .onAppear {
                                rotation = 360
                            }

                        Text("Försöker aktivera förbannelsen...")
                            .foregroundColor(.red)
                            .font(.system(size: 18, weight: .medium, design: .serif))
                            .padding(.top, 10)
                    }
                   
                }
               /* .onAppear {
                               SoundManager.shared.playEffectSound(named: "boo")
                           }*/
                          
            }
            
        }
    }

/*#Preview {
    LoadingView()
}*/
