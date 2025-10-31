//
//  MyProgressViewModel.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

import Foundation
import SwiftUI

// MARK: - Data Models
// DIPINDAHKAN: Definisi Model (Trophy) sekarang ada di file ViewModel,
// bukan di file View.
struct Trophy: Identifiable {
    let id = UUID()
    let milestone: Int
    let isAchieved: Bool
}

// MARK: - Progress View Model
@Observable
class MyProgressViewModel {
    
    // Properti ini adalah "source of truth"
    var currentWeeklyMinutes: Int = 0
    var totalWeeklyMinutes: Int = 0
    var trophies: [Trophy] = []
    
    init() {
        loadUserProgress()
    }
    
    // Logika untuk memuat data (sebelumnya @State) ada di sini
    func loadUserProgress() {
        self.currentWeeklyMinutes = 15
        self.totalWeeklyMinutes = 30
        self.trophies = [
            Trophy(milestone: 3, isAchieved: true),
            Trophy(milestone: 5, isAchieved: true),
            Trophy(milestone: 10, isAchieved: false),
            Trophy(milestone: 15, isAchieved: false),
            Trophy(milestone: 20, isAchieved: false),
            Trophy(milestone: 25, isAchieved: false)
        ]
    }
}
