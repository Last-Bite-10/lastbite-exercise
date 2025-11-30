//
//  ExerciseRow.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

import SwiftUI

struct ExerciseRowComponent: View {
    let title: String
    let duration: Int
    let isCompleted: Bool
    var action: () -> Void
    var exercise: Exercise
    var buttonState: ExerciseButtonState

    @State private var showTutorial = false

    // MARK: - Setups for each button states
    var buttonText: String {
        switch buttonState {
        case .btnPlay, .btnDisabled:
            return "Play"
        case .btnRecording:
            return "In Progress"
        }
    }

    var buttonIcon: String {
        switch buttonState {
        case .btnPlay, .btnDisabled:
            return "play.fill"
        case .btnRecording:
            return "record.circle"
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 12) {
                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.green)
                }
                Text(title)
                    .font(.system(.headline, weight: .bold))
                    .foregroundStyle(
                        isCompleted ? Color(.secondaryLabel) : Color(.label)
                    )
                    .strikethrough(isCompleted)

                Image(systemName: "info.circle.fill")
                    .foregroundStyle(.title)
                    .onTapGesture {
                        showTutorial = true
                    }
            }

            Spacer()

            Text("\(duration) mins")
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(Color(.secondaryLabel))
                .padding(.trailing, 16)

            if !isCompleted {
                ButtonWSound(
                    disabled: buttonState == .btnDisabled,
                    action: action
                ) {
                    HStack(spacing: 8) {
                        Image(systemName: buttonIcon)
                            .font(.headline)
                        Text(buttonText)
                            .font(.headline)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .layoutPriority(1)
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .foregroundStyle(.white)
                    .background(
                        Capsule(style: .continuous)
                            .fill(
                                buttonState == .btnDisabled
                                    ? .disabled : .button
                            )
                    )
                }
            } else {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark")
                        .font(.headline)
                    Text("Done")
                        .font(.headline)
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .foregroundStyle(.white)
                .background(
                    Capsule(style: .continuous)
                        .fill(.green)
                )
            }
        }
        .sheet(isPresented: $showTutorial) {
            ExerciseTutorial(exercise: exercise)
                .presentationDragIndicator(.visible)
        }
    }
}
