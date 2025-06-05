//
//  ShopViewModel.swift
//  TheCursedMap
//
//  Created by Emilia Forsheim on 2025-05-27.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ShopViewModel: ObservableObject {
    @Published var coinBalance: Int = 0
    @Published var selectedAvatar: String = "1avatar1"
    @Published var unlockedAvatars: [String] = []
    @Published var allAvatars: [Avatar] = []
    
    
    init() {
        loadUserData()
    }
    
    func loadUserData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(userId).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data() else {
                // If no data exists, load default avatars
                DispatchQueue.main.async {
                    self?.loadAvatars()
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.coinBalance = data["coins"] as? Int ?? 0
                self?.selectedAvatar = data["selectedAvatar"] as? String ?? "1avatar1"
                self?.unlockedAvatars = data["unlockedAvatars"] as? [String] ?? []
                self?.loadAvatars() // Load avatars AFTER getting Firebase data
            }
        }
    }
    
    func saveUserData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let userData: [String: Any] = [
            "coins": coinBalance,
            "selectedAvatar": selectedAvatar,
            "unlockedAvatars": unlockedAvatars
        ]
        
        Firestore.firestore().collection("users").document(userId).setData(userData, merge: true)
    }
    
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

        let freeAvatars = avatars
            .filter { $0.price == 0 }
            .map { $0.imageName }

        for avatar in freeAvatars {
            if !self.unlockedAvatars.contains(avatar) {
                self.unlockedAvatars.append(avatar)
            }
        }


        updateUnlockedAvatars()
    }
    
    func purchase(_ avatar: Avatar) {
        guard !isUnlocked(avatar.imageName), coinBalance >= avatar.price else { return }
        coinBalance -= avatar.price
        unlockedAvatars.append(avatar.imageName)
        selectedAvatar = avatar.imageName
        updateUnlockedAvatars()
        saveUserData() // Add this line
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
