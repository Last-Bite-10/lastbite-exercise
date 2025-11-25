//
//  DailyPlanCard.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 20/11/25.
//

import SwiftUI

struct DailyPlanCard: View {
    @Environment(HomeViewModel.self) private var viewModel

    @ObservedObject var sessionManager: RecordSessionManager
    
    let date: Date
    let records: [ExerciseRecord]
    let isCurrentDay: Bool
    let onStart: (ExerciseRecord) -> Void

    var activeSessionRecord: ExerciseRecord? {
        guard sessionManager.hasActiveSession,
              let session = sessionManager.activeSession else {
            return nil
        }
        return session.record
    }

    var completedSeconds: Int {
        records.reduce(0) { $0 + $1.recordedSeconds }
    }

    var totalSeconds: Int {
        records.reduce(0) { $0 + $1.requiredSeconds }
    }

    var progress: Double {
        guard totalSeconds > 0 else { return 0 }
        return Double(completedSeconds) / Double(totalSeconds)
    }
    
    func btnState(_ record: ExerciseRecord) -> ExerciseButtonState {
        if isCurrentDay {
            return .btnDisabled
        } else {
            if activeSessionRecord == nil {
                return .btnPlay
            } else {
                if
                    activeSessionRecord!.exercise != nil &&
                    activeSessionRecord!.exercise!.id != record.exercise?.id
                {
                    return .btnDisabled
                } else {
                    return .btnRecording
                }
            }
        }
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
                    Text(
                        "\(Int(completedSeconds / 60))/\(Int(totalSeconds / 60)) mins"
                    )
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
                        duration: record.requiredSeconds / 60,
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
        .onAppear {
            viewModel.currentlyViewedDate = date
            viewModel.currentlyViewedPlan = records
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
        sessionManager: RecordSessionManager.shared,
        date: Date(),
        records: [],
        isCurrentDay: true,
        onStart: { _ in }
    ).environment(HomeViewModel())
}
