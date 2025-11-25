//
//  TodaysPlanHeader.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 31/10/25.
//

import SwiftUI

struct WeeklyPlanHeader: View {
    @Environment(HomeViewModel.self) private var viewModel

    var title: String = "This Week's Plan"
    var actionTitle: String = "Modify"

    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.title)

            Spacer()

            ButtonWSound(
                action: {
                    viewModel.showPlanModifySheet = true
                },
                label: {
                    HStack(spacing: 4) {
                        Image(systemName: "pencil")
                            .font(.system(size: 14, weight: .semibold))
                        Text(actionTitle)
                            .font(.headline)
                    }
                    .foregroundColor(Color.button)
                }
            )
            .buttonStyle(.plain)
        }
        .padding(.horizontal)
    }
}

// MARK: - Preview
#Preview {
    WeeklyPlanHeader()
        .environment(HomeViewModel())
}
