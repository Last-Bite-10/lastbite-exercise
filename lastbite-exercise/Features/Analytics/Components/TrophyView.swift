//
//  TrophyView.swift
//  lastbite-exercise
//
//  Created by Niken Larasati on 23/10/25.
//

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
                                Circle()
                                    .strokeBorder(
                                        trophy.isAchieved
                                            ? Color.blue
                                            : Color.gray.opacity(0.3),
                                        lineWidth: 3
                                    )
                                    .frame(width: 60, height: 60)

                                Image(systemName: "medal.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(
                                        trophy.isAchieved
                                            ? .blue : .gray.opacity(0.3)
                                    )
                            }

                            Text("\(trophy.milestone)")
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
        Trophy(milestone: 10, isAchieved: false),
        Trophy(milestone: 15, isAchieved: false),
        Trophy(milestone: 20, isAchieved: false),
    ])
    .padding()
}
