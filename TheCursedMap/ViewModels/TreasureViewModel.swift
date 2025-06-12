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
        var collectibles: [Collectible]
    }
   

    @Published var openedTreasure: Int = 0
    @Published var coins: Int = 0
    @Published var level: Int = 0
    @Published var xp: Int = 0
    @Published var levelUpReward: Int = 0
    @Published var didLevelUp: Bool = false
    @Published var collectibles: [Collectible] = []
    @Published var lastUnlockedCollectibleName: String? = nil  // to print in TreasureRewardView
    @Published var lastLeveledUpCollectible: Collectible? = nil // to print in TreasureRewardView
    
    // Has to do with haunting functions, and to show user if haunted and how much time remains to open next chest, else user loses 20% of collected coins.
    @Published var isHaunted: Bool = false
    @Published var shouldPlayHauntedSound: Bool = false
    @Published var hauntingMessage: String? = nil
    @Published var hauntingTimeRemaining: Int = 0
    private var hauntCountdownTimer: Timer?
    
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
           if isHaunted {
                  isHaunted = false  // if user was haunted, user is now not haunted
                  shouldPlayHauntedSound = false // not playing haunted sound anymore
                  hauntCountdownTimer?.invalidate()// Stop timer
                  hauntCountdownTimer = nil
                  hauntingTimeRemaining = 0  // resett countdown timer
                  hauntingMessage = "Du är inte längre haunted!" // user get a messagae
                  saveProgressToFirestore()
                  return
              }
      
           openedTreasure += 1
           randomXp()
           randomCoins()
           updateLevel()
           applyHauntingChance()
           saveProgressToFirestore()
       }
    /**
     Function that random by 20% chance get user haunted, if user gets haunted a timers sets and counting down. Gives user a chance to get unhaunted if user open a chest before times runs out, if not user will lose coins.
     */
    func applyHauntingChance() {
        let chance = Int.random(in: 1...10)
        if chance <= 10 {  // 20% chance to be Haunted
            isHaunted = true
            shouldPlayHauntedSound = true
            hauntingTimeRemaining = 360 // time remanining
         
            print("You are haunted! Nästa kista blir läskig...")

            hauntCountdownTimer?.invalidate()
            hauntCountdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                
                if self.hauntingTimeRemaining > 0 {
                    self.hauntingTimeRemaining -= 1
                } else {
                    self.hauntCountdownTimer?.invalidate()
                    self.applyHauntingPenalty()
                    
                }
            }
        }
    }
    
    func applyHauntingPenalty() {
        print("Du öppnade ingen kista i tid!")

        let lostCoins = Int(Double(coins) * 0.2) // User didn´t open chest in time and loses 20% of collected coins
        coins = max(coins - lostCoins, 0)
        isHaunted = false
        shouldPlayHauntedSound = false
        hauntingMessage = "Du öppnade ingen kista i tid och förlorade \(lostCoins) mynt!"
        print("Förlorade \(lostCoins) coins pga haunting.")

        saveProgressToFirestore()
    }
    
    func randomCoins(){
        let reward = Int.random(in: 5...20)
        coins += reward
    }
    
    func randomXp(){
        let xpReward = Int.random(in: 10...30)
        xp += xpReward
    }

    func updateLevel() {
        let previousLevel = level
        level = (xp / maxXpPerLevel) + 1
        
        if level > previousLevel {
            grantLevelUpReward()
        }
    }
    func grantLevelUpReward() {
      
        let bonus = 5 // givs user a tiny bonus in form of coins when levelUp.
        coins += bonus
        levelUpReward = bonus
        didLevelUp = true
        rewardRandomCollectible()  //givs user a collectible when levelUp
 
        print(" Level up! You received \(bonus) bonus coins!")

    }
    
    func defaultCollectibles()  -> [Collectible]{
        return [
            Collectible(id: "doll", name: "Dockan", imageName: "collect1", currentCount: 0, requiredCount: 10, reward: 100, level: 0),
            Collectible(id: "deadMan", name: "Dödskallen", imageName: "collect2", currentCount: 0, requiredCount: 10, reward: 50, level: 0),
            Collectible(id: "zombie", name: "Zombien", imageName: "collect3", currentCount: 0, requiredCount: 10, reward: 150, level: 0),
            Collectible(id: "scarecrow", name: "Fågelskrämman", imageName: "collect4", currentCount: 0, requiredCount: 15, reward: 200, level: 0),
            Collectible(id: "hand", name: "Blodiga handen", imageName: "collect5", currentCount: 0, requiredCount: 10, reward: 100, level: 0),
            Collectible(id: "demon", name: "Demonen", imageName: "collect6", currentCount: 0, requiredCount: 10, reward: 120, level: 0),
            Collectible(id: "vampire", name: "Vampyren", imageName: "collect7", currentCount: 0, requiredCount: 10, reward: 125, level: 0)
        ]
       
    }
    /**
     Function gives user a random collectible when user levels up based on xp. collectible can also level upp. and when it does user get a reward. required amount also increase when it levels up.
     */
    func rewardRandomCollectible() {
        guard !collectibles.isEmpty else { return }
        
        let index = Int.random(in: 0..<collectibles.count)
        var item = collectibles[index]
        item.currentCount += 1
        
        print("got collectible: \(collectibles[index].name)")
        lastUnlockedCollectibleName = item.name
        let base = 10
        let expectedLevel = item.currentCount / base

        if expectedLevel > item.level {
            let levelsGained = expectedLevel - item.level
            let totalReward = item.reward * levelsGained
            coins += totalReward
            item.level = expectedLevel
            item.requiredCount = base * (item.level + 1)
            lastLeveledUpCollectible = item 
            print("LEVEL UP for \(item.name) to level \(item.level), requiredCount now \(item.requiredCount)")
        }

        collectibles[index] = item
    }
    // saves coins, level and the amount of opened chests to firestore
    func saveProgressToFirestore() {

        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user is inlogged – could not save")
            return
        }

        let progress = PlayerProgress(
            coins: coins,
            level: level,
            xp: xp,
            openedTreasure: openedTreasure,
            collectibles: collectibles)

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
    // this function i added because I had problem when I added stuff to collecteble that all data been written over and all data was set at default value.
    func mergeCollectibles(loaded: [Collectible], defaults: [Collectible]) -> [Collectible] {
        var merged = loaded

        for defaultItem in defaults {
            if !merged.contains(where: { $0.id == defaultItem.id }) {
                merged.append(defaultItem)
            }
        }

        return merged
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
                self.collectibles = self.mergeCollectibles(loaded: data.collectibles, defaults: self.defaultCollectibles())
             
            } else {
                print("Could not read data or any data does exist.")
                self.collectibles = self.defaultCollectibles()
            
            }
        }
    }
   
}
