//
//  RecordView.swift
//  ExaWatch Watch App
//
//  Created by Ammar Alifian Fahdan on 27/10/25.
//

import SwiftUI

struct RecordView: View {
    @StateObject private var healthManager = WatchHealthManager()
    @StateObject private var viewModel = WatchRecordViewModel()

    var bgCircleColor: Color {
        switch viewModel.timerStatus {
        case .timerBelowBPM: return .disabled.opacity(1)
        case .timerPaused: return .disabled.opacity(1)
        case .timerStarted: return .ring1.opacity(0.2)
        case .timerStopped: return .disabled.opacity(1)
        case .timerOverflown: return .ringOverflow.opacity(1)
        }
    }

    var progressCircleColor: Color {
        switch viewModel.timerStatus {
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
                    .trim(from: 0, to: viewModel.progress)
                    .stroke(
                        progressCircleColor,
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(
                        .easeInOut(duration: 0.5),
                        value: viewModel.progress
                    )

                VStack(spacing: 4) {
                    Text("Active Time").font(.system(size: 10))
                    Text(viewModel.timeRemainingFormatted)
                        .font(
                            .system(
                                size: 20,
                                weight: .semibold,
                                design: .rounded
                            )
                        )

                    Text("BPM").font(.system(size: 10))

                    Text("\(Int(healthManager.heartRate))")
                        .font(
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
                Text("Total Time: **\(viewModel.timeTotalFormatted)** ").font(
                    .system(size: 12)
                )
            }
            Button(action: {
                viewModel.sendProgressToiPhone(
                    data: ProgressData(
                        progress: viewModel.progress,
                        timerStatus: viewModel.timerStatus != .timerPaused
                            || viewModel.timerStatus != .timerStopped
                            ? .timerStarted : .timerPaused,
                        timeRemaining: viewModel.timeRemaining,
                        totalDuration: viewModel.totalDuration
                    )
                )
            }) {
                Text(
                    viewModel.timerStatus == .timerPaused
                        || viewModel.timerStatus == .timerStopped
                        ? "Start" : "Pause"
                )
                .font(.system(size: 24))
                .padding(.all, 0)
                .foregroundStyle(.white)
                .accessibilityLabel("Start")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)

        }
        .onAppear {
            healthManager.startStreaming()
            viewModel.connectToHealthManager(healthManager)
        }
        .onDisappear {
            healthManager.stopStreaming()
        }
    }
}

#Preview {
    RecordView()
}
