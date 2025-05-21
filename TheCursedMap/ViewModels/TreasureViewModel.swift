//
//  TreasureViewModel.swift
//  TheCursedMap
//
//  Created by Jeanette Norberg on 2025-05-21.
//

import Foundation

class TreasureViewModel: ObservableObject {
    
    @Published var openedTreasure: Int = 0
    @Published var coins: Int = 0
    @Published var level: Int = 0
    
    
    var maxCoinsPerLevel: Int {
           return 100
       }

       var progressToNextLevel: Double {
           Double(coins % maxCoinsPerLevel) / Double(maxCoinsPerLevel)
       }
    
// koppla ihop senare med antal fakriska öppnade kistor från kartan
       func openChest() {
           openedTreasure += 1
           coins += 10
           updateLevel()
       }

       private func updateLevel() {
           level = (coins / maxCoinsPerLevel) + 1
       }
   
}
