//
//  RecordView.swift
//  ExaWatch Watch App
//
//  Created by Ammar Alifian Fahdan on 27/10/25.
//

import SwiftUI

struct RecordViewComponent: View {
    @Environment(RecordViewModel.self) private var viewModel

    let record: ExerciseRecord

    var bgCircleColor: Color {
        switch viewModel.timerService?.timerStatus ?? .timerStopped {
        case .timerBelowBPM: return .card.opacity(1)
        case .timerPaused: return .card.opacity(1)
        case .timerStarted: return .ring1.opacity(0.2)
        case .timerStopped: return .card.opacity(1)
        case .timerOverflown: return .ringOverflow.opacity(1)
        }
    }

    var progressCircleColor: Color {
        switch viewModel.timerService?.timerStatus ?? .timerStopped {
        case .timerBelowBPM: return .disabled.opacity(1)
        case .timerPaused: return .disabled.opacity(1)
        case .timerStarted: return .ring2.opacity(1)
        case .timerStopped: return .disabled.opacity(1)
        case .timerOverflown: return .ringOverflow.opacity(1)
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            // Progress Circle
            ZStack {
                Circle()
                    .stroke(
                        bgCircleColor,
                        lineWidth: 12
                    )

                Circle()
                    .trim(from: 0, to: viewModel.timerService?.progress ?? 0)
                    .stroke(
                        progressCircleColor,
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(
                        .easeInOut(duration: 0.5),
                        value: viewModel.timerService?.progress
                    )

                VStack(spacing: 4) {
                    Text("Active Time").font(.system(size: 10))
                    Text(viewModel.remainingTimeFormatted)
                        .font(
                            .system(
                                size: 20,
                                weight: .semibold,
                                design: .rounded
                            )
                        )

                    Text("BPM").font(.system(size: 10))

                    Text(viewModel.heartRate.map(String.init) ?? "--").font(
                        .system(
                            size: 20,
                            weight: .semibold,
                            design: .rounded
                        )
                    )

                    //                    Text(viewModel.isPaused ? "Paused" : "Active")
                    //                        .font(.caption2)
                    //                        .foregroundStyle(.secondary)
                }
            }
            .frame(height: 120)
            //            .padding()

            VStack {
                Text("Total Time: **\(viewModel.totalTimeFormatted)** ").font(
                    .system(size: 12)
                )
            }
            Button(
                action: {
                    viewModel.timerService?.timerStatus
                        != .timerStarted
                        ? viewModel.startRecordTimer()
                        : viewModel.pauseRecordTimer()
                },
                label: {
                    Text(
                        viewModel.timerService?.timerStatus
                            != .timerStarted
                            ? "Start" : "Pause"
                    )
                    .font(.system(size: 24))
                    .padding(.all, 0)
                    .foregroundStyle(.white)
                    .accessibilityLabel("Start")
                }
            )
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
        }
    }
}
