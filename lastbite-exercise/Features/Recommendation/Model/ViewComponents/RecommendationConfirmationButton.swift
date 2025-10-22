//
//  RecommendationButton.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

import SwiftUI

struct RecommendationConfirmationButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
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
        }
        .accessibilityLabel(title)
    }
}

#Preview {
    VStack(spacing: 16) {
        RecommendationConfirmationButton(title: "1 Day (30 Minutes per Day)") {}
            .padding(.horizontal)
        RecommendationConfirmationButton(title: "Get Recommendation") {}
            .padding(.horizontal)
    }
}
