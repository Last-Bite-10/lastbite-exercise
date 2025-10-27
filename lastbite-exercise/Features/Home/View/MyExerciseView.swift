//
//  Analytics.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

import SwiftUI

struct MyExerciseView: View {
    // State untuk data
    @State private var weeklyStreaks = [true, true, false, true, false]
    @State private var currentDate = Date()
    @State private var progress: Double = 0.2
    @State private var completedMinutes = 2
    @State private var totalMinutes = 10
    @State private var historyItems = [
        HistoryItem(
            minutes: 25,
            totalMinutes: 30,
            date: Calendar.current.date(byAdding: .day, value: -9, to: Date())!
        ),
        HistoryItem(
            minutes: 25,
            totalMinutes: 30,
            date: Calendar.current.date(byAdding: .day, value: -9, to: Date())!
        ),
        HistoryItem(
            minutes: 25,
            totalMinutes: 30,
            date: Calendar.current.date(byAdding: .day, value: -9, to: Date())!
        ),
        HistoryItem(
            minutes: 25,
            totalMinutes: 30,
            date: Calendar.current.date(byAdding: .day, value: -9, to: Date())!
        ),
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Streak Section
                    StreakView(weeklyStreaks: weeklyStreaks)
                        .padding(.horizontal)

                    // Today's Plan Section
                    TodaysPlan(
                        date: currentDate,
                        progress: progress,
                        completedMinutes: completedMinutes,
                        totalMinutes: totalMinutes
                    )

                    // Recent History Section
                    RecentHistoryView(historyItems: historyItems)
                        .padding(.horizontal)
                }
                .padding(.top)
            }
            .navigationTitle("My Exercise")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    MyExerciseView()
}
