//
//  WeeklyProgress.swift
//  lastbite-exercise
//
//  Created by Niken Larasati on 23/10/25.
//

import SwiftData
import SwiftUI

struct WeeklyProgressComponent: View {
    @Query(
        sort: \Weekly.weekNumber,
        order: .reverse
    ) private var allWeeks: [Weekly]

    private func getDateString() -> String {
        guard let latestWeek = allWeeks.first else {
            return "Unknown Date"
        }

        var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMMM yyyy"
            return formatter
        }

        let start = dateFormatter.string(from: latestWeek.startDate)

        let end = dateFormatter.string(from: latestWeek.endDate)
        return "\(start) - \(end)"
    }

    private func getMinutes() -> (
        recordedMinutes: Int, requiredMinutes: Int
    ) {
        guard let latestWeek = allWeeks.first else {
            return (0, 0)
        }

        guard let records = latestWeek.records else {
            return (0, 0)
        }

        let recorded = records.reduce(0, { $0 + $1.recordedSeconds })
        let required = records.reduce(0, { $0 + $1.requiredSeconds })

        let recordedMinutes = recorded.getMinutes()
        let requiredMinutes = required.getMinutes()

        return (recordedMinutes, requiredMinutes)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Weekly Progress")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.title)

            Text(getDateString())
                .font(.subheadline)
                .foregroundStyle(.gray)

            HStack(spacing: 20) {
                ZStack {
                    Image("WeeklyProgress")
                        .resizable()
                        .scaledToFill()
                }
                .frame(width: 120, height: 120)

                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text("\(getMinutes().recordedMinutes)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(.title)

                    Text("/\(getMinutes().requiredMinutes) min")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.title)
                }
                .frame(maxWidth: .infinity)

            }
            .padding()
            .background(.card)
            .cornerRadius(20)
        }
    }
}

#Preview {
    WeeklyProgressComponent()
}
