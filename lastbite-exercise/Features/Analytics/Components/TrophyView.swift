//
// TrophyView.swift
// lastbite-exercise
//
// Created by Niken Larasati on 23/10/25.
// swiftlint:disable line_length

import SwiftUI

struct Trophy: Identifiable {
    let id = UUID()
    let milestone: Int
    let isAchieved: Bool
}

struct TrophiesView: View {
    var trophies: [Trophy]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("My Trophies")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(trophies) { trophy in
                        VStack(spacing: 8) {
                            ZStack {
                                let trophyImage = trophy.isAchieved ? "\(trophy.milestone)WeekTrophy" : "LockedWeekTrophy"
                                
                                Image(trophyImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(
                                        trophy.isAchieved
                                            ? .blue : .gray.opacity(0.3)
                                    )
                            }

                            Text("\(trophy.milestone) Weeks")
                                .font(.headline)
                                .foregroundColor(
                                    trophy.isAchieved
                                        ? .blue : .gray.opacity(0.5)
                                )
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
}

#Preview {
    TrophiesView(trophies: [
        Trophy(milestone: 3, isAchieved: true),
        Trophy(milestone: 5, isAchieved: true),
        Trophy(milestone: 7, isAchieved: true),
        Trophy(milestone: 10, isAchieved: true),
        Trophy(milestone: 15, isAchieved: true),
        Trophy(milestone: 25, isAchieved: true),
        Trophy(milestone: 50, isAchieved: true),
    ])
    .padding()
}
