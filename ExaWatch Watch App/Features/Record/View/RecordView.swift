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

    var body: some View {
        VStack(spacing: 20) {
            // Progress Circle
            ZStack {
                Circle()
                    .stroke(
                        !viewModel.isPaused
                            ? Color.accentColor.opacity(0.2)
                            : Color.gray.opacity(0.3),
                        lineWidth: 12
                    )

                Circle()
                    .trim(from: 0, to: viewModel.progress)
                    .stroke(
                        !viewModel.isPaused
                            ? Color.blue
                            : Color.gray,
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
            .padding()

            VStack {
                Text("Total Time: **\(viewModel.timeTotalFormatted)** ").font(
                    .system(size: 12)
                )
            }
            Button(action: {}) {
                Text("Play")
                    .font(.system(size: 16))
                    .padding(.all, 0)
                    .foregroundStyle(Color.white)
                    .accessibilityLabel("Play")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.mini)
            //            .frame(width: .infinity, height: 25)
            //            .tint(Color.accent)

        }
        .onAppear {
            healthManager.requestAuthorization()
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
