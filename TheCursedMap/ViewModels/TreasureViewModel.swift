//
//  TreasureViewModel.swift
//  TheCursedMap
//
//  Created by Jeanette Norberg on 2025-05-21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class TreasureViewModel: ObservableObject {

    struct PlayerProgress: Codable {
        var coins: Int
        var level: Int
        var xp: Int
        var openedTreasure: Int
    }
    
    @Published var openedTreasure: Int = 0
    @Published var coins: Int = 0
    @Published var level: Int = 0
    @Published var xp: Int = 0
   
   init(){
        loadProgressFromFirestore()
    }
    
    var maxXpPerLevel: Int {
           return 150
       }

       var progressToNextLevel: Double {
           Double(xp % maxXpPerLevel) / Double(maxXpPerLevel)
       }
    
       func openChest() {
           openedTreasure += 1
           randomXp()
           randomCoins()
           updateLevel()
           saveProgressToFirestore()
       }
    
    func randomCoins(){
        let reward = Int.random(in: 5...30)
        coins += reward
    }
    
    func randomXp(){
        let xpReward = Int.random(in: 10...30)
        xp += xpReward
    }
    func updateLevel() {
        level = (xp / maxXpPerLevel) + 1
          randomCoins()
       }
  
    // saves coins, level and the amount of opened chests to firestore
    func saveProgressToFirestore() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user is inlogged – could not save")
            return
        }

        let progress = PlayerProgress(coins: coins, level: level, xp: xp, openedTreasure: openedTreasure)

        do {
            let data = try Firestore.Encoder().encode(progress)
            Firestore.firestore().collection("users").document(userId).setData(data, merge: true) { error in
                if let error = error {
                    print("Faild to save: \(error.localizedDescription)")
                } else {
                    print("Saved to firestore")
                }
            }
        } catch {
            print("CodeFailure: \(error.localizedDescription)")
        }
    }
    // load users coins, level and amount of opened chests from firestore to show them in profileView and TreasureView
   func loadProgressFromFirestore() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("users").document(userId).getDocument { snapshot, error in
            if let data = try? snapshot?.data(as: PlayerProgress.self) {
                self.coins = data.coins
                self.level = data.level
                self.xp = data.xp
                self.openedTreasure = data.openedTreasure
            } else {
                print("Could not read data or any data does exist.")
            }
        }
    }
   
}
