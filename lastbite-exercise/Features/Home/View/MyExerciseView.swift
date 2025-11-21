//
//  MyExerciseView.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

import SwiftData
import SwiftUI

struct MyExerciseView: View {
    @State private var recommendationVM = RecommendationViewModel()
    @State private var questionnaireVM = QuestionnaireViewModel()

    @Environment(\.modelContext) private var modelContext

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
    @Query private var allWeeks: [Weekly]

    private var preference: Preference? { preferences.first }
    private let healthKitManager = HealthKitManager.shared

    init() {
        healthKitManager.requestAuthorization()

        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(Color("BlueTwo"))
        ]
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(Color("BlueTwo"))
        ]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    // Streak Section
                    StreakView(allWeeks: allWeeks)
                        .padding(.horizontal)
                        .padding(.bottom, 20)

                    if preference?.planChosen == nil {
                        PlanSelectionView(
                            showQuestionnaire: $showQuestionnaire
                        )
                    } else if showPlan || !records.isEmpty {
                        // Today's Plan Header
                        WeeklyPlanHeader(onModifyTapped: {
                            showPlanModifySheet = true
                        })

                        // Today's Plan Section
                        WeeklyPlanPager()
                            .environment(recommendationVM)
                            .frame(height: 200)
                    }

                    // Recent History Section
                    RecentHistoryView().environment(recommendationVM)
                }
            }
            .navigationTitle("My Exercise")
            .toolbarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showPlanModifySheet) {
            ExerciseSelectionSheet().environment(recommendationVM)
        }.fullScreenCover(isPresented: $showQuestionnaire) {

            let onDoneAction = {
                showQuestionnaire = false

                recommendationVM.setup(modelContext: modelContext)
                if let preference = preference {
                    recommendationVM.initializeWeeklyExercises(
                        preference: preference
                    )
                }

                showPlan = true
            }

            let onCancelAction = {
                showQuestionnaire = false
                preference?.planChosen = nil
            }

            NavigationStack {
                if preference?.planChosen == .beginner {
                    StartSmallView(onDone: onDoneAction)
                } else {
                    StartStrongView(onDone: onDoneAction)
                }
            }
            .environment(questionnaireVM)
            .environment(\.dismissFlow, onCancelAction)
        }
    }
}

#Preview {
    MyExerciseView()
}
