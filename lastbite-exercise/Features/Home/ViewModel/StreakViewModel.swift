//
//  StreakViewModel.swift
//  lastbite-exercise
//
//  Created by Niken Larasati on 31/10/25.
//

import Foundation
import SwiftUI

@Observable
class StreakViewModel {
    
    // Properti yang dipindahkan dari MyExerciseView
    var weeklyStreaks: [Bool] = []

    init() {
        // Logika untuk memuat data (sebelumnya @State) sekarang ada di sini
        loadStreaks()
    }

    // Di masa depan, fungsi ini dapat mengambil data dari ModelContext
    func loadStreaks() {
        // Data hardcoded dipindahkan ke sini
        self.weeklyStreaks = [true, true, false, true, false]
    }
}
