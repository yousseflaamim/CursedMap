//
//  ShopViewModel.swift
//  TheCursedMap
//
//  Created by Emilia Forsheim on 2025-05-27.
//

import Foundation

class ShopViewModel: ObservableObject {
    @Published var coinBalance: Int = 100
    @Published var selectedAvatar: String = "1avatar1"
    @Published var unlockedAvatars: [String] = []
    @Published var allAvatars: [Avatar] = []
    
    func loadAvatars() {
        let avatarCounts: [Int: Int] = [
            1: 4,
            2: 7,
            3: 7,
            4: 6,
            5: 6,
            6: 4,
            7: 4,
            8: 4,
            9: 2
        ]
        
        let prices: [Int: Int] = [
            1: 0,
            2: 25,
            3: 100,
            4: 250,
            5: 500,
            6: 1000,
            7: 1500,
            8: 3000,
            9: 5000
        ]
        
        var avatars: [Avatar] = []

        for (category, count) in avatarCounts {
            let price = prices[category] ?? 0
            for i in 1...count {
                let name = "\(category)avatar\(i)"
                avatars.append(Avatar(imageName: name, category: "\(category)", price: price, isUnlocked: false))
            }
        }

        self.allAvatars = avatars

        self.unlockedAvatars = avatars
            .filter { $0.price == 0 }
            .map { $0.imageName }

        updateUnlockedAvatars()
    }
    
    func purchase(_ avatar: Avatar) {
        guard !isUnlocked(avatar.imageName), coinBalance >= avatar.price else { return }
        coinBalance -= avatar.price
        unlockedAvatars.append(avatar.imageName)
        selectedAvatar = avatar.imageName
        updateUnlockedAvatars()
    }
    
    func isUnlocked(_ name: String) -> Bool {
        unlockedAvatars.contains(name)
    }
    
    func updateUnlockedAvatars() {
        for index in allAvatars.indices {
            allAvatars[index].isUnlocked = unlockedAvatars.contains(allAvatars[index].imageName)
        }
    }
}
