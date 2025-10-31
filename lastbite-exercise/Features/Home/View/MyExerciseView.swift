//
//  Analytics.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

import SwiftUI
import SwiftData

struct MyExerciseView: View {
    // SwiftData context untuk load data asli
    @Environment(\.modelContext) private var modelContext

    // Gunakan ViewModel yang sudah kamu buat
    @State private var viewModel: StreakViewModel

    // STATE LAINNYA (biarkan seperti semula)
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
                ExerciseEntry(name: "Brisk Walk", doneMinutes: 20, targetMinutes: 20),
                ExerciseEntry(name: "Squats", doneMinutes: 10, targetMinutes: 10)
            ]
        ),
        HistoryItem(
            minutes: 25,
            totalMinutes: 30,
            date: Calendar.current.date(byAdding: .day, value: -9, to: Date())!,
            entries: [
                ExerciseEntry(name: "Brisk Walk", doneMinutes: 20, targetMinutes: 20),
                ExerciseEntry(name: "Squats", doneMinutes: 10, targetMinutes: 10)
            ]
        ),
        HistoryItem(
            minutes: 25,
            totalMinutes: 30,
            date: Calendar.current.date(byAdding: .day, value: -9, to: Date())!,
            entries: [
                ExerciseEntry(name: "Brisk Walk", doneMinutes: 20, targetMinutes: 20),
                ExerciseEntry(name: "Squats", doneMinutes: 10, targetMinutes: 10)
            ]
        ),
        HistoryItem(
            minutes: 25,
            totalMinutes: 30,
            date: Calendar.current.date(byAdding: .day, value: -9, to: Date())!,
            entries: [
                ExerciseEntry(name: "Brisk Walk", doneMinutes: 20, targetMinutes: 20),
                ExerciseEntry(name: "Squats", doneMinutes: 10, targetMinutes: 10)
            ]
        )
    ]

    // Init untuk injeksi ViewModel (memudahkan Preview juga)
    init(viewModel: StreakViewModel = StreakViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // STREAK SECTION —> sekarang pakai [StreakWeek]
                    StreakView(weeklyStreaks: viewModel.weeklyStreaks)
                        .padding(.horizontal)

                    // TODAY'S PLAN SECTION
                    TodaysPlan()

                    // RECENT HISTORY SECTION
                    RecentHistoryView(historyItems: historyItems)
                }
            }
            .navigationTitle("My Exercise")
            .navigationBarTitleDisplayMode(.large)
            // Load data dari SwiftData saat tampil
            .task {
                #if DEBUG
                // Saat preview, jangan autoload agar data mock tidak ketimpa
                if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                    return
                }
                #endif

                viewModel.loadStreaks(modelContext: modelContext, maxWeeksToShow: 6, thresholdMinutes: 150)
            }

        }
    }
}

// MARK: - PREVIEWS
#Preview("With Mocked Streak") {
    // Buat ViewModel mock untuk preview
    let mockVM = StreakViewModel()
    mockVM.weeklyStreaks = [
        StreakWeek(weekNumber: 1, status: .achieved),
        StreakWeek(weekNumber: 2, status: .achieved),
        StreakWeek(weekNumber: 3, status: .missed),   // putus → abu-abu
        StreakWeek(weekNumber: 4, status: .achieved),
        StreakWeek(weekNumber: 5, status: .locked),
        StreakWeek(weekNumber: 6, status: .locked)
    ]
    return MyExerciseView(viewModel: mockVM)
}
