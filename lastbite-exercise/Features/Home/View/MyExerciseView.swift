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
    @State private var homeVM = HomeViewModel()

    @Environment(\.modelContext) private var modelContext

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
                            showQuestionnaire: $homeVM.showQuestionnaire
                        )
                    } else if homeVM.showPlan || !records.isEmpty {

                        // Weekly Plan Section
                        WeeklyPlanPager()
                            .environment(recommendationVM)
                            .environment(homeVM)
                    }

                    // Recent History Section
                    RecentHistoryView().environment(recommendationVM)
                }
            }
            .navigationTitle("My Exercise")
            .toolbarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $homeVM.showPlanModifySheet) {
            ExerciseSelectionSheet()
                .environment(recommendationVM)
                .environment(homeVM)
        }
        .fullScreenCover(isPresented: $homeVM.showQuestionnaire) {
            NavigationStack {
                if preference?.planChosen == .beginner {
                    StartSmallView()
                } else {
                    StartStrongView()
                }
            }
            .environment(questionnaireVM)
            .environment(homeVM)
        }
    }
}

#Preview {
    MyExerciseView()
}
