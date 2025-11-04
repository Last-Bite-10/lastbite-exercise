//
//  Analytics.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

import SwiftUI

struct MyExerciseView: View {
    // State untuk data
    @State private var viewModel = RecommendationViewModel()
    @State private var showModifySheet = false
    @State private var weeklyStreaks = [true, true, false, true, false]
    @State private var currentDate = Date()
    @State private var progress: Double = 0.2
    @State private var completedMinutes = 2
    @State private var totalMinutes = 10
    @State private var historyItems = [
        HistoryItem(
            minutes: 25,
            totalMinutes: 30,
            date: Calendar.current.date(byAdding: .day, value: -9, to: Date())!,
            entries: [
                ExerciseEntry(
                    name: "Brisk Walk",
                    doneMinutes: 20,
                    targetMinutes: 20
                ),
                ExerciseEntry(
                    name: "Squats",
                    doneMinutes: 10,
                    targetMinutes: 10
                ),
            ]
        ),
        HistoryItem(
            minutes: 25,
            totalMinutes: 30,
            date: Calendar.current.date(byAdding: .day, value: -9, to: Date())!,
            entries: [
                ExerciseEntry(
                    name: "Brisk Walk",
                    doneMinutes: 20,
                    targetMinutes: 20
                ),
                ExerciseEntry(
                    name: "Squats",
                    doneMinutes: 10,
                    targetMinutes: 10
                ),
            ]
        ),
        HistoryItem(
            minutes: 25,
            totalMinutes: 30,
            date: Calendar.current.date(byAdding: .day, value: -9, to: Date())!,
            entries: [
                ExerciseEntry(
                    name: "Brisk Walk",
                    doneMinutes: 20,
                    targetMinutes: 20
                ),
                ExerciseEntry(
                    name: "Squats",
                    doneMinutes: 10,
                    targetMinutes: 10
                ),
            ]
        ),
        HistoryItem(
            minutes: 25,
            totalMinutes: 30,
            date: Calendar.current.date(byAdding: .day, value: -9, to: Date())!,
            entries: [
                ExerciseEntry(
                    name: "Brisk Walk",
                    doneMinutes: 20,
                    targetMinutes: 20
                ),
                ExerciseEntry(
                    name: "Squats",
                    doneMinutes: 10,
                    targetMinutes: 10
                ),
            ]
        ),
    ]

    private let healthKitManager = HealthKitManager.shared

    init() {
        healthKitManager.requestAuthorization()
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Streak Section
                    StreakView(weeklyStreaks: weeklyStreaks)
                        .padding(.horizontal)

                    // Today's Plan Header
                    TodaysPlanHeader(onModifyTapped: {
                        showModifySheet = true
                    })

                    // Today's Plan Section
                    TodaysPlan().environment(viewModel)

                    // Recent History Section
                    RecentHistoryView(historyItems: historyItems)

                }
            }
            .navigationTitle("My Exercise")
            .navigationBarTitleDisplayMode(.large)
        }.fullScreenCover(isPresented: $showModifySheet) {
            ExerciseSelectionSheet().environment(viewModel)
        }
    }
}

#Preview {
    MyExerciseView()
}
