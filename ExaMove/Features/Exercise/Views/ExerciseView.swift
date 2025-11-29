//
//  MyExerciseView.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

//
//  MyExerciseView.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

import SwiftData
import SwiftUI

struct ExerciseView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var viewModel = ExerciseViewModel()
    @State private var healthKitService = HealthKitService()

    @Query private var preferences: [Preference]

    private var preference: Preference { preferences.first ?? Preference() }

    init() {
        healthKitService.requestAuthorization()

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

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    StreakComponent()
                        .padding(.horizontal)
                        .padding(.bottom, 20)

                    if !preference.finishQuestionnaire {
                        PlanSelectionComponent().environment(viewModel)
                    } else {
                        //                        WeeklyPlanPager()
                        //                            .frame(height: 300)
                    }

                    HistoryComponent()
                }
            }
            .navigationTitle("My Exercise")
            .toolbarTitleDisplayMode(.large)
        }

        // ✅ Move the environment-based bindings here (AFTER body starts)
        //        .sheet(isPresented: $viewModel.showPlanModifySheet) {
        //            ExerciseSelectionSheet()
        //                .environment(recommendationVM)
        //                .environment(homeVM)
        //        }
        //        .fullScreenCover(isPresented: $viewModel.showQuestionnaire) {
        //            NavigationStack {
        //                if preference.planChosen == .beginner {
        //                    StartSmallView()
        //                } else {
        //                    StartStrongView()
        //                }
        //            }
        //        }

    }
}

#Preview {
    ExerciseView()
}
