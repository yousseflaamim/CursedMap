//
//  SoundManager.swift
//  TheCursedMap
//
//  Created by Jeanette Norberg on 2025-05-21.
//

import Foundation
import AVFoundation

class SoundManager: ObservableObject  {
    
    static let shared = SoundManager()
    private var player: AVAudioPlayer?
    
    // this is to save users choise sound on/off
    @Published var isSoundEnabled: Bool {
            didSet {
                UserDefaults.standard.set(isSoundEnabled, forKey: "isSoundEnabled")
            }
        }
    
    // this is to read users choise sound on/off from UserDeafaults when the app starts aigain
    private init() {
          self.isSoundEnabled = UserDefaults.standard.bool(forKey: "isSoundEnabled")
      }
    
    func playSound(named name: String, withExtension ext: String = "mp3"){
        
        guard isSoundEnabled else { return }
        
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
         print("Sound file \(name).\(ext) not found")
            return
            }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }
    
    func stopSound() {
            player?.stop()
        }
    
    func toggleSound() {
           isSoundEnabled.toggle()
       }
    
    
}
