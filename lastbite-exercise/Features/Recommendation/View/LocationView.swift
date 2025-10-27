//
//  LocationView.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 23/10/25.
//

import SwiftUI

struct LocationView: View {
    @State private var viewModel = RecommendationViewModel()
    @Environment(HomeViewModel.self) private var homeViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                Text("Choose your preferred frequency")
                    .font(Font.headline)

                Image(systemName: "house.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 210)
                    .foregroundStyle(Color.accentColor)

                Text("Where do you prefer to do your exercise?")
                    .font(.body)
                    .padding(.bottom, 48)

                ForEach(LocationType.allCases, id: \.self) { type in
                    RecommendationSelectionButton(
                        title: type.rawValue,
                        isSelected: viewModel.selectedLocation == type,
                        widthReduction: 160,
                        action: { viewModel.selectedLocation = type }
                    )
                }

                Button(
                    action: {
                        homeViewModel.firstLaunch = false
                        homeViewModel.currentView = .home
                    },
                    label: { RecommendationNavButtonLabel(title: "Next") }
                ).padding(.top, 64)

                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(
                        action: {
                            homeViewModel.firstLaunch = false
                            homeViewModel.currentView = .home
                        },
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
    LocationView().environment(HomeViewModel())
}
