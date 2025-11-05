//
//  HealthKitView.swift
//  Exa
//
//  Created by Ammar Alifian Fahdan on 20/10/25.
//

import Combine
import HealthKit
import SwiftData
import SwiftUI

enum TimerStatus {
    case timerPaused
    case timerStarted
    case timerStopped
    case timerOverflown
}

struct RecordView: View {
    @StateObject private var healthKitManager: HealthKitManager
    @StateObject private var viewModel: RecordViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    init(record: ExerciseRecord, modelContext: ModelContext) {
        let manager = HealthKitManager()
        _viewModel = StateObject(wrappedValue: RecordViewModel(
            record: record,
            healthKitManager: manager,
            modelContext: modelContext
        ))
    }

    var body: some View {
        VStack {
            ZStack {
                // Background circle
                Circle()
                    .stroke(
                        !viewModel.isPaused
                            ? Color.accentColor.opacity(0.2)
                            : Color.cardGray.opacity(1),
                        lineWidth: 30
                    )

                // Progress circle
                Circle()
                    .trim(from: 0, to: viewModel.progress)
                    .stroke(
                        !viewModel.isPaused
                            ? Color.blueTwo
                            : Color.pausedGray,
                        style: StrokeStyle(lineWidth: 30, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(
                        .easeInOut(duration: 0.5),
                        value: viewModel.progress
                    )

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
                                    viewModel.isBPMUnder
                                        ? Color.red : Color.black
                                )
                        } else {

                            if !viewModel.isReceivingFromWatch {
                                Text("Apple Watch not connected")
                            }
                            Text("--")
                                .font(.title)
                                .fontWeight(.bold)
                        }

                        if viewModel.isReceivingFromWatch {
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

            VStack {
                Text("Total Time").font(.title2).padding(.bottom, 4)

                Text(viewModel.totalTimeFormatted).font(.title).fontWeight(
                    .bold
                )
            }
            .padding(.vertical, 36)

            VStack {
                RecordPlayButton(title: viewModel.isPaused ? "Start" : "Pause")
                {
                    viewModel.togglePause()
                }

                Button("End") {
                    viewModel.finishExercise()
                    dismiss()
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
