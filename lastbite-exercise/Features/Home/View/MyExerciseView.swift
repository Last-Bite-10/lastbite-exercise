//
//  Analytics.swift (MyExerciseView.swift)
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

import SwiftUI

struct MyExerciseView: View {
    
    // DIHAPUS: @State private var weeklyStreaks
    // DIHAPUS: @State private var historyItems
    
    // DITAMBAHKAN: ViewModels untuk mengelola state
    @State private var streakViewModel = StreakViewModel()
    @State private var historyViewModel = HistoryViewModel()
    
    // State yang tersisa (belum diminta untuk dipindahkan)
    @State private var currentDate = Date()
    @State private var progress: Double = 0.2
    @State private var completedMinutes = 2
    @State private var totalMinutes = 10
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Streak Section
                    // DIUBAH: Menggunakan data dari streakViewModel
                    StreakView(weeklyStreaks: streakViewModel.weeklyStreaks)
                        .padding(.horizontal)
                        
                    // Today's Plan Section
                    // (Masih menggunakan @State lokal, sesuai instruksi)
                    TodaysPlan()
                        
                    // Recent History Section
                    // DIUBAH: Menggunakan data dari historyViewModel
                    RecentHistoryView(historyItems: historyViewModel.historyItems)
                        
                }
            }
            .navigationTitle("My Exercise")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    MyExerciseView()
}
