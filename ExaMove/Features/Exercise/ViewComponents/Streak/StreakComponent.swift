//
//  StreakView.swift
//  lastbite-exercise
//
//  Created by Niken Larasati on 23/10/25.
//

import SwiftData
import SwiftUI

struct StreakComponent: View {
    @Query private var allWeeks: [Weekly]

    // 🐛 DEBUG: State untuk override streak status
    @State private var debugStreakOverrides: [Int: Bool] = [:]

    // Flag untuk enable/disable debug mode
    @State private var isDebugMode = true  // Set false untuk production

    private var sortedWeeks: [Weekly] {
        allWeeks.sorted { $0.weekNumber < $1.weekNumber }
    }

    var hasAnyStreak: Bool {
        // Check both real data and debug overrides
        if isDebugMode && !debugStreakOverrides.isEmpty {
            return debugStreakOverrides.values.contains(true)
        }
        return sortedWeeks.contains(where: { $0.isStreakAchieved == true })
    }

    private var weeksByNumber: [Int: Weekly] {
        Dictionary(uniqueKeysWithValues: allWeeks.map { ($0.weekNumber, $0) })
    }

    var body: some View {
        VStack(alignment: .leading) {
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
                                Circle().fill(.card)

                                Image(systemName: iconName)
                                    .foregroundColor(iconColor)
                                    .font(.system(size: 24))
                            }
                            .frame(width: 40, height: 40)

                            Text("W\(weekNumber)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        // 🐛 DEBUG: Tap gesture untuk toggle streak
                        .onTapGesture {
                            if isDebugMode {
                                toggleDebugStreak(for: weekNumber)
                            }
                        }
                    }
                }
                .padding(.horizontal, 30)
            }
            .padding(.vertical, 20)
            .background(Color(.white))
            .cornerRadius(20)

            if !hasAnyStreak {
                HStack(spacing: 8) {
                    ZStack {
                        Image("WeakStreak")
                            .resizable()
                            .scaledToFill()
                    }
                    .frame(width: 150, height: 100)

                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                            Text("No streaks yet!")
                                .font(.headline)
                        }
                        Text("Start exercising to get \nthe fire going!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .cornerRadius(12)
            }

            if hasAnyStreak {
                HStack(spacing: 8) {
                    ZStack {
                        Image("CommonStreak")
                            .resizable()
                            .scaledToFill()
                    }
                    .frame(width: 150, height: 100)

                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.orange)

                            Text("1 Streak")
                                .font(.headline)
                        }
                        Text("Keep the Streak Going!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .cornerRadius(12)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .strokeBorder(Color(.systemGray4).opacity(0.4), lineWidth: 0.5)
        )
    }

    // 🐛 DEBUG: Function untuk toggle streak status
    private func toggleDebugStreak(for weekNumber: Int) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            if let currentValue = debugStreakOverrides[weekNumber] {
                debugStreakOverrides[weekNumber] = !currentValue
            } else {
                // Jika belum ada override, set berdasarkan data asli atau default false
                let currentStatus =
                    weeksByNumber[weekNumber]?.isStreakAchieved ?? false
                debugStreakOverrides[weekNumber] = !currentStatus
            }
        }

        // 🐛 DEBUG: Print untuk tracking
        Debugging.debug(
            "🐛 Week \(weekNumber) toggled to: \(debugStreakOverrides[weekNumber] ?? false)"
        )
    }

    private func getIconStyle(for weekNumber: Int, data: Weekly?) -> (
        String, Color
    ) {
        let grayColor = Color.gray.opacity(0.8)

        // 🐛 DEBUG: Check override first
        if isDebugMode, let overrideValue = debugStreakOverrides[weekNumber] {
            if overrideValue {
                return ("flame.fill", .orange)
            } else {
                return ("flame.fill", grayColor)
            }
        }

        // Original logic
        if let week = data {
            if week.isStreakAchieved {
                return ("flame.fill", .orange)
            } else {
                return ("flame.fill", grayColor)
            }
        }
        if weekNumber == 1 {
            return ("flame.fill", grayColor)
        }

        if let previousWeek = weeksByNumber[weekNumber - 1],
            previousWeek.isStreakAchieved
        {
            return ("flame.fill", grayColor)
        } else {
            return ("lock.fill", grayColor)
        }
    }
}

#Preview {
    StreakComponent()
}
