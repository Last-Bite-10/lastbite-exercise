//
//  MyExerciseView.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

import SwiftData
import SwiftUI
import SwiftData

struct MyExerciseView: View {
    @State private var viewModel = RecommendationViewModel()
    @State private var showQuestionnaire: Bool = false
    @State private var showPlan: Bool = false
    @State private var showPlanModifySheet = false
    @State private var weeklyStreaks = [true, true, false, true, false]
    @State private var currentDate = Date()
    @State private var progress: Double = 0.2
    @State private var completedMinutes = 2
    @State private var totalMinutes = 10

    @Query private var preferences: [Preference]
    @Query private var records: [ExerciseRecord]

    private let healthKitManager = HealthKitManager.shared

    init() {
        healthKitManager.requestAuthorization()
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    // Streak Section
                    StreakView(weeklyStreaks: weeklyStreaks)
                        .padding(.horizontal)

                    if preferences.first?.planChosen == nil {
                        PlanSelectionView(
                            showQuestionnaire: $showQuestionnaire
                        )
                    } else if showPlan || !records.isEmpty {
                        // Today's Plan Header
                        TodaysPlanHeader(onModifyTapped: {
                            showPlanModifySheet = true
                        })

                        // Today's Plan Section
                        TodaysPlan().environment(viewModel)
                    }

                    // Recent History Section
                    RecentHistoryView().environment(viewModel)
                        .padding(.top, -20)
                }
            }
            .navigationTitle("My Exercise")
            .navigationBarTitleDisplayMode(.large)
        }.fullScreenCover(isPresented: $showPlanModifySheet) {
            ExerciseSelectionSheet().environment(viewModel)
        }.fullScreenCover(isPresented: $showQuestionnaire) {
            if preferences.first?.planChosen == .beginner {
                NavigationStack {
                    BeginnerPlanView(onDone: {
                        showQuestionnaire = false
                        showPlan = true
                    })
                }
            } else {
                NavigationStack {
                    FrequencyView(onDone: {
                        showQuestionnaire = false
                        showPlan = true
                    })
                }
            }
        }
    }
}

#Preview {
    MyExerciseView()
}
