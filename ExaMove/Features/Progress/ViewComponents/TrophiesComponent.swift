//
// TrophyView.swift
// lastbite-exercise
//
// Created by Niken Larasati on 23/10/25.
//

import SwiftData
import SwiftUI

struct Trophy: Identifiable, Equatable {
    let id = UUID()
    let milestone: Int
    var isAchieved: Bool
}

struct TrophiesComponent: View {
    @State private var trophies = [
        Trophy(milestone: 3, isAchieved: false),
        Trophy(milestone: 5, isAchieved: false),
        Trophy(milestone: 7, isAchieved: false),
        Trophy(milestone: 10, isAchieved: false),
        Trophy(milestone: 15, isAchieved: false),
        Trophy(milestone: 25, isAchieved: false),
        Trophy(milestone: 50, isAchieved: false),
    ]

    @Query(
        filter: #Predicate<Weekly> { $0.isCompleted == true },
    ) private var completedWeeks: [Weekly]

    private let columns = [
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
                    #if DEBUG
                        toggleAllTrophies()
                    #endif
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
                .onChange(of: completedWeeks) {
                    let milestone = completedWeeks.count
                    let index = trophies.firstIndex(
                        of: .init(milestone: milestone, isAchieved: false)
                    )!

                    trophies[index].isAchieved = true
                }
            }
        }
    }
}

#Preview {
    TrophiesComponent()
}
