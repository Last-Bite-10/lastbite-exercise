//
//  RecommendationView.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

import SwiftUI

enum RecommendationType: String, CaseIterable {
    case oneDay = "1 Day (30 Minutes per Day)"
    case twoDays = "2 Day (15 Minutes per Day)"
    case threeDays = "3 Days (10 Minutes per Day)"
    case fourDays = "4 Days (8 Minutes per Day)"
    case fiveDays = "5 Days (6 Minutes per Day)"
}

struct RecommendationView: View {
    @State private var selectedType: RecommendationType = .oneDay

    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                Text("Choose your preferred frequency")
                    .font(Font.headline)

                Image(systemName: "clock")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 210)
                    .foregroundStyle(Color.accentColor)

                ForEach(RecommendationType.allCases, id: \.self) { type in
                    RecommendationButton(
                        title: type.rawValue,
                        isSelected: selectedType == type,
                        action: { selectedType = type }
                    )
                }

                RecommendationConfirmationButton(
                    title: "Next",
                    action: {}
                ).padding(.top, 64)

                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(
                        action: {},
                        label: {
                            Text("Skip")
                                .foregroundColor(.red)
                        }
                    ).buttonStyle(.borderless)
                }
            }
        }
    }
}

#Preview {
    RecommendationView()
}
