//
//  WrongAnswerView.swift
//  TheCursedMap
//
//  Created by Jeanette Norberg on 2025-05-26.
//

import SwiftUI
import AVFoundation
import AVKit

struct WrongAnswerView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var player: AVAudioPlayer?
    @State private var videoPlayer = AVPlayer()
    
    let dismissAction: () -> Void
    
    private let scaryClips: [(video: String, sound: String)] = [
        (video: "creepy-doll", sound: "doll-laugh"),
        (video: "creep", sound: "creep-sound"),
        (video: "demon", sound: "demon-laugh"),
        (video: "ghost", sound: "ghost"),
        (video: "scary", sound: "ghost-scream"),
        (video: "skeletons", sound: "scary-laugh")
    ]
    private let gifNames = ["creeapy-doll", "creepy", "demon", "ghost", "scary", "skeletons"]
    
    var body: some View {
        ZStack {
            // Bakground
            LinearGradient(
                gradient: Gradient(colors: [Color("GrayBlack"), Color("Gray"), Color("GrayBlack")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            VStack {
                
                VideoPlayer(player: videoPlayer)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        playRandomGif()
                    }
                
                    
                    Button("HOPPA ÖVER") {
                        SoundManager.shared.playButtonSound(named: "click-click")
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.system(size: 18, weight: .medium, design: .serif))
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.gray)
                    .cornerRadius(10)
                    .padding(.bottom, 40)
                
            }
            .background(Color.black)
        }
       
                
           
            
            
        }
    
    func playRandomGif(){
        guard let clip = scaryClips.randomElement(),
              let url = Bundle.main.url(forResource: clip.video, withExtension: "mp4") else {
                  print("Kunde inte slumpa fram eller hitta en video")
                  return
              }

              videoPlayer.replaceCurrentItem(with: AVPlayerItem(url: url))
        SoundManager.shared.playEffectSound(named: clip.sound)
              videoPlayer.play()

              DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                  presentationMode.wrappedValue.dismiss()
              }
          }
    }



#Preview {
    WrongAnswerView(dismissAction: {})
}
