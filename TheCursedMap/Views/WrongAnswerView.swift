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
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.system(size: 24, weight: .medium, design: .serif))
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.red)
                    .cornerRadius(10)
                    .padding(.bottom, 40)
                
            }
            .background(Color.black)
        }
       
                
           
            
            
        }
    
    func playRandomGif(){
        guard let clip = scaryClips.randomElement(),
              let url = Bundle.main.url(forResource: clip.video, withExtension: "mp4") else {
                  print("❌ Kunde inte slumpa fram eller hitta en video")
                  return
              }

              videoPlayer.replaceCurrentItem(with: AVPlayerItem(url: url))
        SoundManager.shared.playSound(named: clip.sound) // Du kan också slumpa ljud om du vill!
              videoPlayer.play()

              DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                  presentationMode.wrappedValue.dismiss()
              }
          }
    }



#Preview {
    WrongAnswerView()
}
