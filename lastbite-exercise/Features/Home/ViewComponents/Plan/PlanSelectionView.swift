//
//  PlanSelectionView.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 05/11/25.
//

import SwiftData
import SwiftUI

struct PlanSelectionView: View {
    @Binding var showQuestionnaire: Bool
    @Query private var preferences: [Preference]

    private var preference: Preference? { preferences.first }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("Choose Your Plan")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.title)

            PlanCardView(
                title: "Start Strong!",
                subtitle: "Start with the WHO recommended 150 mins per week!",
                image: "StartStrong",
                action: {
                    showQuestionnaire = true
                    preference?.planChosen = .expert
                }
            )

            PlanCardView(
                title: "Start Small!",
                subtitle:
                    "Start small with our gradual habit building beginner-friendly plan!",
                image: "StartSmall",
                action: {
                    showQuestionnaire = true
                    preference?.planChosen = .beginner
                }
            )
        }
        .padding()
    }
}

#Preview {
    PlanSelectionView(showQuestionnaire: .constant(false))
}
