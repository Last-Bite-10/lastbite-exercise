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
                        Image(systemName: weeklyStreaks[index] ? "flame.fill" : "flame")
                            .foregroundColor(weeklyStreaks[index] ? .orange : .gray.opacity(0.3))
                            .font(.system(size: 24))
                        
                        Text("W\(index + 1)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemGray6))
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
                                .font(.headline)
                        }
                        Text("Start exercising to get\nthe fire going!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
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
                                .font(.headline)
                        }
                        Text("Start exercising to get\nthe fire going!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color.pink.opacity(0.1))
                .cornerRadius(12)
            }
            
        }
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
