//
// TrophyView.swift
// lastbite-exercise
//
// Created by Niken Larasati on 23/10/25.
//

import SwiftUI

struct Trophy: Identifiable {
    let id = UUID()
    let milestone: Int
    var isAchieved: Bool
}

struct TrophiesView: View {
    @Binding var trophies: [Trophy]

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    private func toggleAllTrophies() {
        let shouldAchieve = !(trophies.first?.isAchieved ?? false)

        for index in trophies.indices {
            trophies[index].isAchieved = shouldAchieve
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("My Trophies")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.title)
                .onTapGesture {
                    toggleAllTrophies()
                }

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(trophies) { trophy in
                    VStack(spacing: 8) {
                        ZStack {
                            let trophyImage =
                                trophy.isAchieved
                                ? "\(trophy.milestone)WeekTrophy"
                                : "Locked\(trophy.milestone)WeekTrophy"

                            Image(trophyImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .background(.card)
                                .cornerRadius(20)
                        }

                        Text("\(trophy.milestone) Weeks Streak Trophy")
                            .font(.caption)
                            .foregroundColor(
                                trophy.isAchieved
                                    ? .black : .gray.opacity(0.5)
                            )
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}
