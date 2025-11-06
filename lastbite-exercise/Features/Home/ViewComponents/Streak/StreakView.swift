//
//  StreakView.swift
//  lastbite-exercise
//
//  Created by Niken Larasati on 23/10/25.
//

import SwiftUI

// MARK: - Styling helper via enum extension (hindari large_tuple)
extension StreakStatus {
    var icon: String {
        switch self {
        case .achieved: return "flame.fill"
        case .missed:   return "flame"
        case .locked:   return "lock.fill"
        }
    }
    var bgColor: Color {
        switch self {
        case .achieved: return Color.orange.opacity(0.15)
        case .missed:   return Color.gray.opacity(0.15)
        case .locked:   return Color(.systemGray6)
        }
    }
    var fgColor: Color {
        switch self {
        case .achieved: return .orange
        case .missed:   return .gray
        case .locked:   return .gray.opacity(0.8)
        }
    }
    var iconOpacity: Double {
        switch self {
        case .achieved: return 1.0
        case .missed:   return 1.0
        case .locked:   return 0.8
        }
    }
}

struct StreakView: View {
    var weeklyStreaks: [StreakWeek]

    var hasAnyStreak: Bool {
        weeklyStreaks.contains { $0.status == .achieved }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // --- UI Streak (scrollable horizontal) ---
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(weeklyStreaks) { week in
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(week.status.bgColor)
                                    .frame(width: 48, height: 48)
                                Image(systemName: week.status.icon)
                                    .foregroundColor(week.status.fgColor)
                                    .opacity(week.status.iconOpacity)
                                    .font(.system(size: 22, weight: .semibold))
                            }
                            Text("W\(week.weekNumber)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Week \(week.weekNumber)")
                        .accessibilityValue({
                            switch week.status {
                            case .achieved: return "achieved"
                            case .missed:   return "missed"
                            case .locked:   return "locked"
                            }
                        }())
                    }
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .background(Color(.white))
            .cornerRadius(12)

            // --- Promo / Copywriting box ---
            HStack(spacing: 16) {
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.system(size: 50))
                    .foregroundColor(.pink.opacity(0.7))

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: hasAnyStreak ? "flame.fill" : "flame")
                            .foregroundColor(hasAnyStreak ? .orange : .gray)
                        Text(hasAnyStreak ? "Keep the Streak Going!" : "No streaks yet!")
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
}

// MARK: - PREVIEWS
#Preview("No Streak Yet (week 1 belum 150)") {
    StreakView(weeklyStreaks: [
        StreakWeek(weekNumber: 1, status: .missed),
        StreakWeek(weekNumber: 2, status: .locked),
        StreakWeek(weekNumber: 3, status: .locked),
        StreakWeek(weekNumber: 4, status: .locked),
        StreakWeek(weekNumber: 5, status: .locked),
        StreakWeek(weekNumber: 6, status: .locked)
    ])
    .padding()
}

#Preview("Streak Ongoing (week 1 & 2 tercapai)") {
    StreakView(weeklyStreaks: [
        StreakWeek(weekNumber: 1, status: .achieved),
        StreakWeek(weekNumber: 2, status: .achieved),
        StreakWeek(weekNumber: 3, status: .locked),
        StreakWeek(weekNumber: 4, status: .locked),
        StreakWeek(weekNumber: 5, status: .locked),
        StreakWeek(weekNumber: 6, status: .locked)
    ])
    .padding()
}

#Preview("Putus di Week 3 (abu-abu), Muncul Lagi Week 4") {
    StreakView(weeklyStreaks: [
        StreakWeek(weekNumber: 1, status: .achieved),
        StreakWeek(weekNumber: 2, status: .achieved),
        StreakWeek(weekNumber: 3, status: .missed),   // putus → abu-abu
        StreakWeek(weekNumber: 4, status: .achieved), // muncul lagi
        StreakWeek(weekNumber: 5, status: .locked),
        StreakWeek(weekNumber: 6, status: .locked)
    ])
    .padding()
}

#Preview("Dark Mode") {
    StreakView(weeklyStreaks: [
        StreakWeek(weekNumber: 1, status: .achieved),
        StreakWeek(weekNumber: 2, status: .achieved),
        StreakWeek(weekNumber: 3, status: .missed),
        StreakWeek(weekNumber: 4, status: .achieved)
    ])
    .padding()
    .preferredColorScheme(.dark)
}
