//
//  TrophyViewModel.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

//import SwiftUI
//
//@Observable
//class TrophyViewModel {
//    @Published var currentStreak: Int = 0
//    
//    @Published var trophies: [Trophy]
//    
//    init(trophies: [Trophy]) {
//        self.trophies = trophies
//    }
//    
//    func updateStreak(isCompleted: Bool) {
//        if isCompleted {
//            currentStreak += 1
//        } else {
//            currentStreak = 0
//        }
//        
//        updateTrophy()
//    }
//    
//    func updateTrophy() {
//        for index in trophies.indices {
//            let milestone = trophies[index].milestone
//            if currentStreak >= milestone {
//                trophies[index].isAchieved = true
//            }
//        }
//    }
//}
