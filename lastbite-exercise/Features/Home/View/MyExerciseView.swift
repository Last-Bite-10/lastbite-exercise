//
//  MyExerciseView.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

import SwiftData
import SwiftUI

struct MyExerciseView: View {
    @State private var viewModel = RecommendationViewModel()
    @State private var questionnaireViewModel = QuestionnaireViewModel()

    @State private var showPlanModifySheet = false

    @Query private var preferences: [Preference]
    @Query private var records: [ExerciseRecord]
    @Query private var allWeeks: [Weekly]

    @Environment(\.modelContext) private var modelContext

    private let healthKitManager = HealthKitManager.shared

    private var questionnaireBinding: Binding<Bool> {
        Binding(
            get: {
                guard let pref = preferences.first else { return false }
                return pref.planChosen != nil
                    && !(pref.questionnaireCompleted)
            },
            set: { _ in
            }
        )
    }

    init() {
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(Color.blueTwo)
        ]
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(Color.blueTwo)
        ]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    // Streak Section
                    StreakView(allWeeks: allWeeks)
                        .padding(.horizontal)
                        .padding(.bottom, 20)

                    if preferences.first?.planChosen == nil
                        || !(preferences.first?.questionnaireCompleted
                            ?? false)
                    {
                        PlanSelectionView()
                    } else {
                        TodaysPlanHeader(onModifyTapped: {
                            showPlanModifySheet = true
                        })
                        TodaysPlan().environment(viewModel)
                    }

                    // Recent History Section
                    RecentHistoryView().environment(viewModel)
                    //    .padding(.top, -20)
                }
            }
            .navigationTitle("My Exercise")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                healthKitManager.requestAuthorization()
            }
        }.sheet(isPresented: $showPlanModifySheet) {
            ExerciseSelectionSheet().environment(viewModel)
        }.fullScreenCover(isPresented: questionnaireBinding) {

            let onDoneAction = {
                if preferences.first != nil {
                    preferences.first?.questionnaireCompleted = true
                    try? modelContext.save()
                }
            }

            let onCancelAction = {
                if preferences.first != nil {
                    preferences.first?.planChosen = nil
                    preferences.first?.questionnaireCompleted = false
                    try? modelContext.save()
                }
            }

            NavigationStack {
                if preferences.first?.planChosen == .beginner {
                    BeginnerPlanView(onDone: onDoneAction)
                } else {
                    FrequencyView(onDone: onDoneAction)
                }
            }
            .environment(questionnaireViewModel)
            .environment(\.dismissFlow, onCancelAction)
        }
    }
}

#Preview {
    MyExerciseView()
}
