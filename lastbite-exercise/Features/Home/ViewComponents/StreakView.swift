//
//  StreakView.swift
//  lastbite-exercise
//
//  Created by Niken Larasati on 23/10/25.
//

import SwiftUI

struct StreakView: View {
    var weeklyStreaks: [Bool]
    
    // Computed property untuk mengecek apakah ada streak
    var hasAnyStreak: Bool {
        weeklyStreaks.contains(true)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Weekly Streak
            HStack(spacing: 20) {
                ForEach(0..<weeklyStreaks.count, id: \.self) { index in
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color(.systemGray6))
                            
                            Image(systemName: weeklyStreaks[index] ? "flame.fill" : "flame")
                                .foregroundColor(weeklyStreaks[index] ? .orange : .gray.opacity(0.8))
                                .font(.system(size: 24))
                        }
                        Text("W\(index + 1)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.white))
            .cornerRadius(12)
            
            // No Streaks Message - hanya muncul jika tidak ada streak
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
}

#Preview("No Streaks") {
    StreakView(weeklyStreaks: [false, false, false, false, false])
        .padding()
}

#Preview("Some Streaks") {
    StreakView(weeklyStreaks: [true, true, false, true, false])
        .padding()
}

#Preview("All Streaks") {
    StreakView(weeklyStreaks: [true, true, true, true, true])
        .padding()
}
