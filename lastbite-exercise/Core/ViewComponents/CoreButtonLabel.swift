//
//  RecommendationNavButtonLabel.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

import SwiftUI

struct CoreButtonLabel: View {
    var title: String

    var body: some View {
        Text(title)
            .font(.subheadline)
            .padding(.vertical, 12)
            .padding(.horizontal, 28)
            .frame(width: UIScreen.main.bounds.width - 128)
            .foregroundStyle(Color.white)
            .background(
                Capsule()
                    .fill(Color.interactiveBlue)
            )
            .accessibilityLabel(title)
    }
}

#Preview {
    VStack(spacing: 16) {
        CoreButtonLabel(
            title: "1 Day (30 Minutes per Day)"
        )
        .padding(.horizontal)
        CoreButtonLabel(title: "Get Recommendation")
            .padding(.horizontal)
    }
}
