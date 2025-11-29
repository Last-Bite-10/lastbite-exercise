//
//  PlanCardView.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

import SwiftUI

struct PlanCardComponent: View {
    let title: String
    let subtitle: String
    let image: String
    let action: () -> Void

    var body: some View {
        HStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)

            VStack(alignment: .leading, spacing: 16) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))

                Text(subtitle)
                    .font(.footnote)

                ButtonWSound(action: action) {
                    Text("Choose")
                        .font(.subheadline)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(.button)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(.card)
        .cornerRadius(28)
    }
}

#Preview {
    PlanCardComponent(
        title: "7 Days Plan",
        subtitle: "A comprehensive 7-day plan to kickstart your journey.",
        image: "StartStrong",
        action: {
            Debugging.debug("Plan chosen")
        }
    )
}
