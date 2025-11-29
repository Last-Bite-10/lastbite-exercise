//
//  PlanSelectionView.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

//
//  PlanSelectionView.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 05/11/25.
//

import SwiftData
import SwiftUI

struct PlanSelectionComponent: View {
    @Environment(ExerciseViewModel.self) private var viewModel
    @Query private var preferences: [Preference]

    private var preference: Preference? { preferences.first }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Choose Your Plan")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.title)

            PlanCardComponent(
                title: "Start Small!",
                subtitle:
                    "Start small with our gradual habit building beginner-friendly plan!",
                image: "StartSmall",
                action: {
                    viewModel.showQuestionnaire = true
                    preference?.planChosen = .beginner
                }
            )

            PlanCardComponent(
                title: "Start Strong!",
                subtitle: "Start with the WHO recommended 150 mins per week!",
                image: "StartStrong",
                action: {
                    viewModel.showQuestionnaire = true
                    preference?.planChosen = .expert
                }
            )
        }
        .padding()
    }
}

#Preview {
    PlanSelectionComponent().environment(ExerciseViewModel())
}
