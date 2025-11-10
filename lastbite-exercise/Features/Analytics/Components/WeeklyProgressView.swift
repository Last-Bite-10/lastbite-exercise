//
//  WeeklyProgress.swift
//  lastbite-exercise
//
//  Created by Niken Larasati on 23/10/25.
//

import SwiftUI

struct WeeklyProgressView: View {
    var currentMinutes: Int
    var totalMinutes: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Progress")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))

            HStack(spacing: 20) {
                // Exercise illustration
                Image(systemName: "figure.step.training")
                    .font(.system(size: 80))
                    .foregroundColor(.pink)

                Spacer()

                // Minutes display
                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text("\(currentMinutes)")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))

                    Text("/\(totalMinutes) min")
                        .font(.title3)
                        .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

#Preview {
    WeeklyProgressView(currentMinutes: 15, totalMinutes: 30)
        .padding()
}
