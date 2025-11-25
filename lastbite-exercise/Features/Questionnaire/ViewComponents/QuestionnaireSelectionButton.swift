//
//  RecommendationSelectionButton.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

import SwiftUI

struct QuestionnaireSelectionButton: View {
    var title: String
    var isSelected: Bool = false
    var action: () -> Void

    var body: some View {
        ButtonWSound(
            action: action,
            label: {
                Text(title)
                    .font(.body)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity)  // expand to grid column
                    .foregroundStyle(isSelected ? .white : .black)
                    .background(
                        Capsule()
                            .fill(isSelected ? .button : .card)
                    )
            }
        )
        .accessibilityLabel(title)
    }
}

#Preview {
    VStack(spacing: 16) {
        QuestionnaireSelectionButton(title: "1 Day (30 Minutes per Day)") {}
            .padding(.horizontal)
        QuestionnaireSelectionButton(title: "Get Recommendation") {}
            .padding(.horizontal)
    }
}
