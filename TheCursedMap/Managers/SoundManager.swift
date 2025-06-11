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
    private var backgroundPlayer: AVAudioPlayer?
    
    // this is to save users choise sound on/off
    @Published var isSoundEnabled: Bool {
            didSet { UserDefaults.standard.set(isSoundEnabled, forKey: "isSoundEnabled")
               
            }
        }
    @Published var isBackgroundSoundEnabled: Bool {
        didSet { UserDefaults.standard.set(isBackgroundSoundEnabled, forKey: "isBackgroundSoundEnabled") }

    }

    @Published var isButtonSoundEnabled: Bool {
        didSet { UserDefaults.standard.set(isButtonSoundEnabled, forKey: "isButtonSoundEnabled") }
    }
    
    @Published var isEffectSoundEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isEffectSoundEnabled, forKey: "isEffectSoundEnabled")
        }
    }
    
    // this is to read users choise sound on/off from UserDeafaults when the app starts aigain
    private init() {
           self.isSoundEnabled = UserDefaults.standard.bool(forKey: "isSoundEnabled")
           self.isBackgroundSoundEnabled = UserDefaults.standard.bool(forKey: "isBackgroundSoundEnabled")
           self.isButtonSoundEnabled = UserDefaults.standard.bool(forKey: "isButtonSoundEnabled")
           self.isEffectSoundEnabled = UserDefaults.standard.bool(forKey: "isEffectSoundEnabled")
      }
    
    // play click sound when user presses buttons
    func playButtonSound(named name: String){
        // check users settings
        guard isSoundEnabled && isButtonSoundEnabled else { return }

           guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
               print("Sound file \(name).mp3 not found")
               return
           }

           do {
               player = try AVAudioPlayer(contentsOf: url)
               player?.prepareToPlay()
               player?.play()
           } catch {
               print("Failed to play button sound: \(error.localizedDescription)")
           }
    }
    // plays background music
    func playBackGroundSound(named name: String, ext: String = "mp3"){
        //check users settings
        guard isSoundEnabled && isBackgroundSoundEnabled else { return }
           
           if backgroundPlayer?.isPlaying == true { return }

           guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
               print("Musikfil \(name).\(ext) hittades inte")
               return
           }
           
           do {
               backgroundPlayer = try AVAudioPlayer(contentsOf: url)
               backgroundPlayer?.numberOfLoops = -1
               backgroundPlayer?.prepareToPlay()
               backgroundPlayer?.play()
               print("Bakgrundsmusik startad: \(name)")
           } catch {
               print("Misslyckades spela musik: \(error.localizedDescription)")
           }
    }
    // plays sound effects
    func playEffectSound(named name: String, completion: (() -> Void)? = nil) {
        //check users settings
        guard isSoundEnabled && isEffectSoundEnabled else { return }
        
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            self.player = player
            player.play()

            DispatchQueue.main.asyncAfter(deadline: .now() + player.duration) {
                completion?()
            }

        } catch {
            print("Kunde inte spela ljud: \(error)")
            completion?()
        }
    }
    // stops backround sound or all sound
    func stopBackgroundMusic() {
        backgroundPlayer?.stop()
        backgroundPlayer = nil
    }

    func stopAllSounds() {
        backgroundPlayer?.stop()
        backgroundPlayer = nil
        player?.stop()
        player = nil
    }
    // check and save users choice of sound
    func toggleBackgroundSound() {
        isBackgroundSoundEnabled.toggle()
           
           if !isBackgroundSoundEnabled {
               stopBackgroundMusic()
           }
    }

    func toggleButtonSound() {
        isButtonSoundEnabled.toggle()
    }

    func toggleEffectSound() {
        isEffectSoundEnabled.toggle()
    }
    func toggleSound() {
        isSoundEnabled.toggle()
          
          if !isSoundEnabled {
              stopAllSounds()
          }
       }
    
    
}
