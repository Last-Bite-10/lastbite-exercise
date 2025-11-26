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

    @Environment(HomeViewModel.self) private var homeVM
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
            .foregroundColor: UIColor(.title)
        ]
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(.title)
        ]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    private var bindingForPlanModifySheet: Binding<Bool> {
        Binding(
            get: { homeVM.showPlanModifySheet },
            set: { homeVM.showPlanModifySheet = $0 }
        )
    }

    private var bindingForShowQuestionnaire: Binding<Bool> {
        Binding(
            get: { homeVM.showQuestionnaire },
            set: { homeVM.showQuestionnaire = $0 }
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    StreakView(allWeeks: allWeeks)
                        .padding(.horizontal)
                        .padding(.bottom, 20)

                    if preference?.planChosen == nil {
                        PlanSelectionView(
                            showQuestionnaire: bindingForShowQuestionnaire
                        )
                    } else if homeVM.showPlan || !records.isEmpty {
                        WeeklyPlanPager()
                            .environment(recommendationVM)
                            .environment(homeVM)
                            .frame(height: 300)
                    }

                    RecentHistoryView()
                        .environment(recommendationVM)
                }
            }
            .navigationTitle("My Exercise")
            .toolbarTitleDisplayMode(.large)
        }

        // ✅ Move the environment-based bindings here (AFTER body starts)
        .sheet(isPresented: bindingForPlanModifySheet) {
            ExerciseSelectionSheet()
                .environment(recommendationVM)
                .environment(homeVM)
        }
        .fullScreenCover(isPresented: bindingForShowQuestionnaire) {
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
    MyExerciseView().environment(HomeViewModel())
}
