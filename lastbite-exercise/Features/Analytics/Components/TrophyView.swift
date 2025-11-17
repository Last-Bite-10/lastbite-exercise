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
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("My Trophies")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))

            LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(trophies) { trophy in
                        VStack(spacing: 8) {
                            ZStack {
                                let trophyImage = trophy.isAchieved ? "\(trophy.milestone)WeekTrophy" : "LockedWeekTrophy"
                                
                                Image(trophyImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 150)
                                    .background(Color("CardGray"))
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
