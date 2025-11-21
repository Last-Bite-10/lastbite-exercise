//
//  DailyPlanCard.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 20/11/25.
//

import SwiftUI

struct DailyPlanCard: View {
    let date: Date
    let records: [ExerciseRecord]
    let isCurrentDay: Bool
    let onStart: (ExerciseRecord) -> Void

    var completedMinutes: Int {
        records.reduce(0) { $0 + $1.recordedMinutes }
    }

    var totalMinutes: Int {
        records.reduce(0) { $0 + $1.requiredMinutes }
    }

    var progress: Double {
        guard totalMinutes > 0 else { return 0 }
        return Double(completedMinutes) / Double(totalMinutes)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // MARK: - Header
            HStack {
                Text(
                    date.formatted(
                        .dateTime.weekday(.wide).day().month(.wide).year()
                    )
                )
                .font(.headline.bold())

                Spacer()

                VStack(alignment: .trailing) {
                    Text("\(Int(progress * 100))%")
                        .font(.subheadline.bold())
                    Text("\(completedMinutes)/\(totalMinutes) mins")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            ProgressBar(value: progress)
                .frame(height: 12)

            Divider()

            // MARK: - Exercise List
            VStack(spacing: 20) {
                ForEach(records) { record in
                    ExerciseRow(
                        title: record.exercise?.name ?? "Exercise",
                        duration: Int(record.requiredMinutes),
                        isCompleted: record.isCompleted,
                        action: {
                            if isCurrentDay {
                                onStart(record)
                            }
                        },
                        exercise: record.exercise!,
                        disableStartButton: !isCurrentDay
                    )
                }
            }

        }
        .frame(maxWidth: .infinity, alignment: .leading)  // allow horizontal expansion
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(Color(.systemGray4).opacity(0.4), lineWidth: 0.5)
        )
        .layoutPriority(1)  // prefer to grow rather than be compressed
    }
}

#Preview {
    DailyPlanCard(
        date: Date(),
        records: [],
        isCurrentDay: true,
        onStart: { _ in }
    )
}
