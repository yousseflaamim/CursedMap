//
//  SwiftUIView.swift
//  TheCursedMap
//
//  Created by Jeanette Norberg on 2025-06-04.
//

import SwiftUI
import AVKit

struct WelcomeView: View {
    @Binding var show: Bool
    @State private var scale: CGFloat = 0.6
    @State private var opacity: Double = 0.0

    var body: some View {
           ZStack {
               Color.black.opacity(0.7).ignoresSafeArea()

               VStack {
                   
                   Image("creepySpider")
                       .resizable()
                       .scaledToFit()
                       .frame(width: 350, height: 350)
                       .scaleEffect(scale)
                       .opacity(opacity)
                       .onAppear {
                           SoundManager.shared.playEffectSound(named: "boo")
                           withAnimation(.easeOut(duration: 0.8)) {
                               scale = 1.8
                               opacity = 1.0
                           }
                           DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                              
                               withAnimation(.easeIn(duration: 0.5)) {
                                   opacity = 0.0
                               }
                               DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                   show = false
                               }
                           }
                       }
               }
           }
       }
}

/*#Preview {
    WelcomeView()
}*/
