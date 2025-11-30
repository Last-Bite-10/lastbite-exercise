//
//  ExerciseRow.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 07/11/25.
//

import SwiftUI

enum ExerciseButtonState {
    case btnDisabled
    case btnPlay
    case btnRecording
}

struct ExerciseRowComponent: View {
    @Environment(RecordViewModel.self) private var viewModel

    var record: ExerciseRecord
    var action: (() -> Void)?

    var buttonState: ExerciseButtonState {
        if viewModel.timerService?.timerStatus == .timerStarted {
            return viewModel.record == record ? .btnRecording : .btnDisabled
        } else {
            return .btnPlay
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
        HStack {
            VStack(alignment: .leading) {
                Text(record.exercise?.name ?? "")
                    .font(.headline)
                    .foregroundStyle(.black)
                Text(
                    "\(record.requiredSeconds.getMinutes() - record.recordedSeconds.getMinutes()) mins"
                )
                .font(.caption2)
                .foregroundStyle(.black)
            }

            Spacer()

            NavigationLink(
                destination: RecordView(record: record).environment(viewModel)
            ) {
                Image(systemName: buttonIcon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(10)
            }
            .simultaneousGesture(
                TapGesture().onEnded {
                    action?()
                }
            )
            .buttonStyle(.plain)
            .background(
                Circle().fill(buttonState == .btnDisabled ? .disabled : .button)
            )
            .clipShape(Circle())
            .disabled(buttonState == .btnDisabled)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.card)
        )
    }
}
