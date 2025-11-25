//
//  ExerciseRow.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 30/10/25.
//

import SwiftUI

enum ExerciseButtonState {
    case btnDisabled
    case btnPlay
    case btnRecording
}

struct ExerciseRow: View {
    let title: String
    let duration: Int
    let isCompleted: Bool
    var action: () -> Void
    var exercise: Exercise
    var buttonState: ExerciseButtonState

    @State private var showTutorial = false

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
                    .foregroundColor(Color.title)
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
                ButtonWSound(disabled: disableStartButton, action: action) {
                    HStack(spacing: 8) {
                        Image(systemName: "play.fill")
                            .font(.headline)
                        Text("Start")
                            .font(.headline)
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .foregroundStyle(.white)
                    .background(
                        Capsule(style: .continuous)
                            .fill(
                                disableStartButton
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
