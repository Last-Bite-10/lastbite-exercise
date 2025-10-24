//
//  Analytics.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

import SwiftUI

struct MyExercise: View {
    @State private var weeklyStreaks = [true, true, true, false, true]
    @State private var exercises = [
        Exercise(name: "Brisk Walk", duration: 20, icon: "figure.walk"),
        Exercise(name: "Cardio Dance", duration: 10, icon: "figure.dance")
    ]
    @State private var completedMinutes = 2
    @State private var totalMinutes = 10
    @State private var historyItems = [
        HistoryItem(minutes: 25, totalMinutes: 30, date: Calendar.current.date(byAdding: .day, value: -8, to: Date())!),
        HistoryItem(minutes: 25, totalMinutes: 30, date: Calendar.current.date(byAdding: .day, value: -8, to: Date())!),
        HistoryItem(minutes: 25, totalMinutes: 30, date: Calendar.current.date(byAdding: .day, value: -8, to: Date())!),
        HistoryItem(minutes: 25, totalMinutes: 30, date: Calendar.current.date(byAdding: .day, value: -8, to: Date())!)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Streak Section
                    StreakView(weeklyStreaks: weeklyStreaks)

                    // Today's Plan Section
                    TodaysPlanView(
                        exercises: exercises,
                        completedMinutes: completedMinutes,
                        totalMinutes: totalMinutes,
                        date: Date(),
                        onStartExercise: { exercise in
                            print("Starting exercise: \(exercise.name)")
                            // Handle start exercise
                        },
                        onModify: {
                            print("Modify plan tapped")
                            // Handle modify
                        }
                    )

                    // Recent History Section
                    RecentHistoryView(historyItems: historyItems)
                }
                .padding()
            }
            .navigationTitle(Text("My Exercise"))
        }
    }
}

#Preview {
    MyExercise()
}
