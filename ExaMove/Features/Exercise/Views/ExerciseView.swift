//
//  MyExerciseView.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

import SwiftData
import SwiftUI

struct ExerciseView: View {
    @Environment(\.modelContext) private var modelContext

    @Binding var showTutorialOverlay: Bool

    @State private var healthKitService = HealthKitService()
    @State private var viewModel = ExerciseViewModel()

    @Query private var preferences: [Preference]

    private var preference: Preference { preferences.first ?? Preference() }

    init(showTutorialOverlay: Binding<Bool>) {
        _showTutorialOverlay = showTutorialOverlay

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
                        WeeklyExerciseComponent(
                            healthKitService: healthKitService
                        )
                        .frame(height: 300)
                        .environment(viewModel)
                    }

                    HistoryComponent().environment(viewModel)
                }
            }
            .navigationTitle("My Exercise")
            .toolbarTitleDisplayMode(.large)
        }
        .onAppear {
            viewModel.setup(modelContext: modelContext)
        }

        .sheet(isPresented: $viewModel.showPlanModifySheet) {
            ExerciseSelectionView().environment(viewModel)
        }

        .fullScreenCover(isPresented: $viewModel.showQuestionnaire) {
            NavigationStack {
                if preference.planChosen == .beginner {
                    StartSmallView {
                        viewModel.showQuestionnaire = false
                        viewModel.initializeWeeklyExercises(
                            preference: preference
                        )
                        showTutorialOverlay = true
                    }
                } else {
                    StartStrongView {
                        viewModel.showQuestionnaire = false
                        viewModel.initializeWeeklyExercises(
                            preference: preference
                        )
                        showTutorialOverlay = true
                    }
                }
            }
        }
    }
}

#Preview {
    ExerciseView(showTutorialOverlay: .constant(false))
}
