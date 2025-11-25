//
//  WeeklyProgress.swift
//  lastbite-exercise
//
//  Created by Niken Larasati on 23/10/25.
//

import SwiftData
import SwiftUI

struct WeeklyProgressView: View {
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

        guard let endDate = latestWeek.endDate else {
            return "\(start) - Unknown Date"
        }

        let end = dateFormatter.string(from: endDate)
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

        var recorded = records.reduce(0, { $0 + $1.recordedSeconds })
        var required = records.reduce(0, { $0 + $1.requiredSeconds })

        recorded /= 60
        required /= 60

        return (recorded, required)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Weekly Progress")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.title)

            Text(getDateString())
                .font(.subheadline)
                .foregroundColor(.gray)

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
                        .foregroundColor(.title)

                    Text("/\(getMinutes().requiredMinutes) min")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.title)
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
    WeeklyProgressView()
}
