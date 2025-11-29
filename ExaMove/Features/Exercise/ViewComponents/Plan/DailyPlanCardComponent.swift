//
//  DailyPlanCard.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

import SwiftUI

enum ExerciseButtonState {
    case btnDisabled
    case btnPlay
    case btnRecording
}

struct DailyPlanCardComponent: View {
    let date: Date
    let records: [ExerciseRecord]
    let isCurrentDay: Bool
    let onStart: (ExerciseRecord) -> Void

    var completedSeconds: TimeInterval {
        records.reduce(0) { $0 + $1.recordedSeconds }
    }

    var totalSeconds: TimeInterval {
        records.reduce(0) { $0 + $1.requiredSeconds }
    }

    var progress: Double {
        guard totalSeconds > 0 else { return 0 }

        return completedSeconds / totalSeconds
    }

    // ✅ Computed property untuk mendapatkan exercise pertama
    var firstExercise: Exercise? {
        records.first?.exercise
    }

    func btnState(_ record: ExerciseRecord) -> ExerciseButtonState {
        if !isCurrentDay {
            return .btnDisabled
        } else {
            if records.contains(where: { records in
                records.isRecording
            }) {
                return record.isRecording ? .btnRecording : .btnDisabled
            } else {
                return .btnPlay
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            HStack(spacing: 12) {
                if let exercise = firstExercise {
                    Image(exercise.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                VStack(spacing: 8) {
                    HStack {
                        Text(
                            date.formatted(
                                .dateTime.weekday(.wide).day().month(.wide)
                                    .year()
                            )
                        )
                        .font(.headline.bold())

                        Spacer()

                        VStack(alignment: .trailing, spacing: 2) {
                            Text("\(Int(progress * 100))%")
                                .font(.subheadline.bold())
                            Text(
                                "\(completedSeconds.getMinutes())/\(totalSeconds.getMinutes()) mins"
                            )
                            .font(.caption)
                            .foregroundColor(.secondary)
                        }
                    }

                    ProgressBarComponent(value: progress)
                        .frame(height: 12)
                }
            }

            Divider()

            // MARK: - Exercise List
            VStack(spacing: 20) {
                ForEach(records) { record in
                    PlanRowComponent(
                        title: record.exercise?.name ?? "Exercise",
                        duration: record.requiredSeconds.getMinutes(),
                        isCompleted: record.isCompleted,
                        action: {
                            onStart(record)
                        },
                        exercise: record.exercise!,
                        buttonState: btnState(record)
                    )
                }
            }

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(Color(.systemGray4).opacity(0.4), lineWidth: 0.5)
        )
        .layoutPriority(1)
    }
}

#Preview {
    DailyPlanCardComponent(
        date: Date(),
        records: [],
        isCurrentDay: true,
        onStart: { _ in }
    ).environment(ExerciseViewModel())
}
