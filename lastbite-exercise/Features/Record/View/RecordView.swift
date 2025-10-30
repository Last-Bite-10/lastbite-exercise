//
//  HealthKitView.swift
//  Exa
//
//  Created by Ammar Alifian Fahdan on 20/10/25.
//

import SwiftUI
import HealthKit
import Combine

// func formatTime(duration: Int) -> String {
//    return "\(String(format: "%02d", duration / 60)):\(String(format: "%02d", duration % 60))"
// }

enum TimerStatus {
    case timerPaused
    case timerStarted
    case timerStopped
    case timerOverflown
}

struct RecordView: View {
    @StateObject private var healthKitManager = HealthKitManager()
    @StateObject private var viewModel: RecordViewModel
    
    init(totalTime: Int) {
        let manager = HealthKitManager()
        _healthKitManager = StateObject(wrappedValue: manager)
        _viewModel = StateObject(wrappedValue: RecordViewModel(totalTime: totalTime, healthKitManager: manager))
    }

    var body: some View {
        VStack {
            ZStack {
                // Background circle
                Circle()
                    .stroke(
                        !viewModel.isPaused
                        ? Color.accentColor.opacity(0.2)
                        : Color.gray2.opacity(1),
                        lineWidth: 30
                    )

                // Progress circle
                Circle()
                    .trim(from: 0, to: viewModel.progress)
                    .stroke(
                        !viewModel.isPaused
                        ? Color.blue2
                        : Color.gray3,
                        style: StrokeStyle(lineWidth: 30, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: viewModel.progress)

                VStack {
                    VStack {
                        Text("Active Time")
                        Text(viewModel.activeTimeFormatted)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }.padding(.bottom, 12)

                    VStack {
                        Text("BPM")

                        if let bpm = viewModel.currentBPM {
                            Text("\(bpm)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(
                                    viewModel.isBPMUnder ? Color.red : Color.black
                                )
                        } else {
                            Text("--")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        
                        if viewModel.isReceivingFromWatch {
                            Image(systemName: "applewatch")
                                .foregroundStyle(.blue)
                                .font(.caption)
                        }
                    }
                }
            }
            .frame(width: 260, height: 260)

            VStack {
                Text("Total Time").font(.title2).padding(.bottom, 4)

                Text(viewModel.totalTimeFormatted).font(.title).fontWeight(.bold)
            }
            .padding(.vertical, 36)

            VStack {
                RecordPlayButton(title: viewModel.isPaused ? "Start" : "Pause") {
                    viewModel.togglePause()
                }

                Button("End") {
                    viewModel.finishExercise()
                }
            }
        }
        .onAppear {
            viewModel.startMonitoring()
        }
        .onDisappear {
            viewModel.stopMonitoring()
        }
    }
}

#Preview {
    RecordView(totalTime: 100)
}
