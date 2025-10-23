//
//  RecommendationSelectionButton.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

import SwiftUI

struct RecommendationSelectionButton: View {
    var title: String
    var isSelected: Bool = false
    var widthReduction: CGFloat = 64
    var action: () -> Void

    var body: some View {
        Button(
            action: action,
            label: {
                Text(title)
                    .font(.body)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 28)
                    .frame(width: UIScreen.main.bounds.width - widthReduction)
                    .foregroundStyle(isSelected ? Color.white : Color.black)
                    .background(
                        Capsule()
                            .fill(isSelected ? Color.blue2 : Color.gray2)
                    )
            }
        )
        .accessibilityLabel(title)
    }
}

#Preview {
    VStack(spacing: 16) {
        RecommendationSelectionButton(title: "1 Day (30 Minutes per Day)") {}
            .padding(.horizontal)
        RecommendationSelectionButton(title: "Get Recommendation") {}
            .padding(.horizontal)
    }
}
