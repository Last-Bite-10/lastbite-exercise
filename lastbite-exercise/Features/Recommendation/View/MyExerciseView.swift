//
//  Analytics.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

import SwiftData
import SwiftUI

struct MyExerciseView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var currentWeekly: Weekly?
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
    @Query private var weekly: [Weekly]

    init() {
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Streak Section
                    StreakView(weeklyStreaks: weeklyStreaks)
                        .padding(.horizontal)

                    // Today's Plan Section
                    TodaysPlan()

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
