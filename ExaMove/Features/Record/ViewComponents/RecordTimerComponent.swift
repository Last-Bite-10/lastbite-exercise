//
//  RecordTimerComponent.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

import SwiftUI

struct RecordTimerComponent: View {
    @Environment(RecordViewModel.self) private var viewModel

    var bgCircleColor: Color {
        let status = viewModel.timerService?.timerStatus ?? .timerStopped
        switch status {
        case .timerBelowBPM: return .card.opacity(1)
        case .timerPaused: return .card.opacity(1)
        case .timerStarted: return .ring1.opacity(0.2)
        case .timerStopped: return .card.opacity(1)
        case .timerOverflown: return .ringOverflow.opacity(1)
        }
    }

    var progressCircleColor: Color {
        let status = viewModel.timerService?.timerStatus ?? .timerStopped
        switch status {
        case .timerBelowBPM: return .disabled.opacity(1)
        case .timerPaused: return .disabled.opacity(1)
        case .timerStarted: return .ring2.opacity(1)
        case .timerStopped: return .disabled.opacity(1)
        case .timerOverflown: return .ringOverflow.opacity(1)
        }
    }

    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(
                    bgCircleColor,
                    lineWidth: 30
                )

            // Progress circle
            Circle()
                .trim(from: 0, to: viewModel.timerService?.progress ?? 0)
                .stroke(
                    progressCircleColor,
                    style: StrokeStyle(lineWidth: 30, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(
                    .easeInOut(duration: 0.5),
                    value: viewModel.timerService?.progress ?? 0
                )

            VStack {
                VStack {
                    Text("Active Time")
                    Text(
                        "\( (viewModel.timerService?.remainingTime ?? 0) < 0 ? "+" : "")\(viewModel.remainingTimeFormatted)"
                    )
                    .font(.largeTitle)
                    .fontWeight(.bold)
                }.padding(.bottom, 12)

                VStack {
                    Text("BPM")

                    if let bpm = viewModel.heartRate {
                        Text("\(Int(bpm))")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(
                                (viewModel.timerService?.timerStatus
                                    == .timerBelowBPM)
                                    ? .red : .black
                            )
                    } else {
                        Text("--")
                            .font(.title)
                            .fontWeight(.bold)
                    }

                    if viewModel.heartRate != nil {
                        Image(systemName: "applewatch")
                            .foregroundStyle(.blue)
                            .font(.caption)
                    } else {
                        Image(systemName: "applewatch.slash")
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                }
            }
        }
        .frame(width: 260, height: 260)
    }
}

#Preview {
    RecordTimerComponent().environment(RecordViewModel())
}
