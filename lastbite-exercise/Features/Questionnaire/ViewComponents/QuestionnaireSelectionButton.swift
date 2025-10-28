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
    var widthReduction: CGFloat = 64
    var action: () -> Void

    var body: some View {
        Button(
            action: action,
            label: {
                GeometryReader { geometry in
                    let targetWidth = max(
                        0,
                        geometry.size.width - widthReduction
                    )
                    Text(title)
                        .font(.body)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 28)
                        .frame(width: targetWidth, alignment: .center)
                        .foregroundStyle(isSelected ? Color.white : Color.black)
                        .background(
                            Capsule()
                                .fill(isSelected ? Color.blue2 : Color.gray2)
                        )
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .center
                        )
                }
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
