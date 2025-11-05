//
//  MyExerciseView.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

import SwiftUI

struct MyExerciseView: View {
    @State private var viewModel = RecommendationViewModel()
    @State private var showModifySheet = false
    @State private var weeklyStreaks = [true, true, false, true, false]
    @State private var currentDate = Date()
    @State private var progress: Double = 0.2
    @State private var completedMinutes = 2
    @State private var totalMinutes = 10

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    StreakView(weeklyStreaks: weeklyStreaks)
                        .padding(.horizontal)

                    TodaysPlanHeader(onModifyTapped: {
                        showModifySheet = true
                    })

                    TodaysPlan().environment(viewModel)

                    // Recent History Section
                    RecentHistoryView().environment(viewModel)
                }
            }
            .navigationTitle("My Exercise")
            .navigationBarTitleDisplayMode(.large)
        }
        .fullScreenCover(isPresented: $showModifySheet) {
            ExerciseSelectionSheet().environment(viewModel)
        }
    }
}

#Preview {
    MyExerciseView()
}
