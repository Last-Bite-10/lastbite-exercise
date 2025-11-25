//
//  RecommendationNavButtonLabel.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

import SwiftUI

struct CoreButtonLabel: View {
    let title: String

    private let soundPlayer = SoundPlayer.shared

    var body: some View {
        Text(title)
            .font(.subheadline)
            .padding(.vertical, 12)
            .padding(.horizontal, 28)
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .background(
                Capsule()
                    .fill(.button)
            )
            .accessibilityLabel(title)
    }
}

#Preview {
    VStack(spacing: 16) {
        CoreButtonLabel(
            title: "1 Day (30 Minutes per Day)"
        )
        CoreButtonLabel(title: "Get Recommendation")
    }
    .padding(.horizontal)
}
