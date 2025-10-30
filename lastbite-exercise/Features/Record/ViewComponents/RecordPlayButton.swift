//
//  Exa
//
//  Created by Ammar Alifian Fahdan on 27/10/25.
//

import SwiftUI

struct RecordPlayButton: View {
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
                .accessibilityLabel(title)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        RecommendationNavButtonLabel(
            title: "1 Day (30 Minutes per Day)"
        )
        .padding(.horizontal)
        RecommendationNavButtonLabel(title: "Get Recommendation")
            .padding(.horizontal)
    }
}
