//
//  StreakView.swift
//  lastbite-exercise
//
//  Created by Niken Larasati on 23/10/25.
//

import SwiftUI

struct StreakView: View {
    var allWeeks: [Weekly]

    private var sortedWeeks: [Weekly] {
        allWeeks.sorted { $0.weekNumber < $1.weekNumber }
    }
    
    var hasAnyStreak: Bool {
        sortedWeeks.contains(where: { $0.isStreakAchieved == true })
    }
    
    private var weeksByNumber: [Int: Weekly] {
        Dictionary(uniqueKeysWithValues: allWeeks.map { ($0.weekNumber, $0) })
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(1...10, id: \.self) { weekNumber in
                        let weekData = weeksByNumber[weekNumber]
                        let (iconName, iconColor) = getIconStyle(
                            for: weekNumber,
                            data: weekData
                        )
                        
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(Color(.systemGray6))

                                Image(systemName: iconName)
                                    .foregroundColor(iconColor)
                                    .font(.system(size: 24))
                            }
                            .frame(width: 50, height: 50)
                            
                            Text("W\(weekNumber)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
            .padding(.vertical)
            .background(Color(.white))
            .cornerRadius(12)

            if !hasAnyStreak {
                HStack(spacing: 16) {
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 50))
                        .foregroundColor(.pink.opacity(0.7))

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Image(systemName: "flame")
                                .foregroundColor(.gray)
                            Text("No streaks yet!")
                                .font(.subheadline)
                        }
                        Text("Start exercising to get the fire going!")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.pink.opacity(0.1))
                .cornerRadius(12)
                .frame(maxWidth: .infinity)
            }

            if hasAnyStreak {
                HStack(spacing: 16) {
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 50))
                        .foregroundColor(.pink.opacity(0.7))

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Image(systemName: "flame")
                            Text("Keep the Streak Going!")
                                .font(.subheadline)
                        }
                        Text("Start exercising to get the fire going!")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.pink.opacity(0.1))
                .cornerRadius(12)
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .strokeBorder(Color(.systemGray4).opacity(0.4), lineWidth: 0.5)
        )
    }
    
    private func getIconStyle(for weekNumber: Int, data: Weekly?) -> (String, Color) {
            let grayColor = Color.gray.opacity(0.8)
            
            if let week = data {
                if week.isStreakAchieved {
                    return ("flame.fill", .orange)
                } else {
                    return ("flame", grayColor)
                }
            }
            if weekNumber == 1 {
                return ("flame", grayColor)
            }
            
            if let previousWeek = weeksByNumber[weekNumber - 1], previousWeek.isStreakAchieved {
                return ("flame", grayColor)
            } else {
                return ("lock.fill", grayColor)
            }
        }
}
