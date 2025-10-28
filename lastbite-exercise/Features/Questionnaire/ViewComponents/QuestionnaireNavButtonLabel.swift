//
//  RecommendationNavButtonLabel.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

import SwiftUI

struct QuestionnaireNavButtonLabel: View {
    var title: String

    var body: some View {
        Text(title)
            .font(.body)
            .padding(.vertical, 12)
            .padding(.horizontal, 28)
            .frame(width: UIScreen.main.bounds.width - 128)
            .foregroundStyle(Color.white)
            .background(
                Capsule()
                    .fill(Color.blue2)
            )
            .accessibilityLabel(title)
    }
}

#Preview {
    VStack(spacing: 16) {
        QuestionnaireNavButtonLabel(
            title: "1 Day (30 Minutes per Day)"
        )
        .padding(.horizontal)
        QuestionnaireNavButtonLabel(title: "Get Recommendation")
            .padding(.horizontal)
    }
}
