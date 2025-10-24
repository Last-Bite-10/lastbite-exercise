//
//  ToolsView.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 23/10/25.
//

import SwiftUI

struct ToolsView: View {
    @State private var viewModel = RecommendationViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                Text(
                    "Help us determined what exercise plan is perfect for you!"
                )
                .font(Font.headline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 300)

                Image(systemName: "dumbbell.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 210)
                    .foregroundStyle(Color.accentColor)

                Text("What tools do you have in your home?")
                    .font(.body)
                    .fontWeight(.semibold)

                Text("(You can choose more than one)")
                    .font(.body)

                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: -24),
                        GridItem(.flexible())
                    ],
                    spacing: 5,
                    content: {
                        ForEach(ToolsType.allCases, id: \.self) { type in
                            RecommendationSelectionButton(
                                title: type.rawValue,
                                isSelected: viewModel.selectedTools.contains(
                                    type
                                ),
                                widthReduction: 240,
                                action: {
                                    if viewModel.selectedTools.contains(type) {
                                        viewModel.selectedTools.remove(type)
                                    } else {
                                        viewModel.selectedTools.insert(type)
                                    }
                                }
                            )
                        }
                    }
                ).padding(.top, 48)

                NavigationLink(
                    destination: LocationView(),
                    label: {
                        RecommendationNavButtonLabel(
                            title: "Get Recommendation"
                        )
                    }
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
    ToolsView()
}
