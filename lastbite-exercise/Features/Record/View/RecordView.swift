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

struct RecordView: View {
    @StateObject private var healthKitManager = HealthKitManager()
    @EnvironmentObject private var watchConnectivityManager:
        WatchConnectivityManager
    @StateObject private var viewModel: RecordViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var bgCircleColor: Color {
        switch viewModel.timerStatus {
        case .timerBelowBPM: return Color.cardGray.opacity(1)
        case .timerPaused: return Color.cardGray.opacity(1)
        case .timerStarted: return Color.accentColor.opacity(0.2)
        case .timerStopped: return Color.cardGray.opacity(1)
        case .timerOverflown: return Color.purple2.opacity(1)
        }
    }

    var progressCircleColor: Color {
        switch viewModel.timerStatus {
        case .timerBelowBPM: return Color.pausedGray.opacity(1)
        case .timerPaused: return Color.pausedGray.opacity(1)
        case .timerStarted: return Color.blueTwo.opacity(1)
        case .timerStopped: return Color.pausedGray.opacity(1)
        case .timerOverflown: return Color.purple2.opacity(1)
        }
    }

    var timerMessage: String {
        switch viewModel.timerStatus {
        case .timerPaused:
            return "The time is paused. Continue by increasing your BPM!"
        case .timerStarted:
            return
                "Your exercise is in progress, your heartbeat is being recorded!"
        case .timerStopped:
            return
                "Start now! Remember only your active time **(BPM >= \(healthKitManager.bpmThreshold ?? -1))** will be recorded."
        case .timerOverflown:
            return
                "Your exercise is in progress, your heartbeat is being recorded!"
        case .timerBelowBPM:
            return "The time is paused. Continue by increasing your BPM!"
        }
    }

    init(record: ExerciseRecord, modelContext: ModelContext) {
        let manager = HealthKitManager()
        _healthKitManager = StateObject(wrappedValue: manager)
        _viewModel = StateObject(
            wrappedValue: RecordViewModel(
                record: record,
                healthKitManager: manager,
                modelContext: modelContext
            )
        )
    }

    var body: some View {
        VStack {
            Text(timerMessage)
                .frame(
                    width: UIScreen.main.bounds.width * 0.6,
                    alignment: .center
                )
                .multilineTextAlignment(.center)
                .padding(.bottom, 32)
            ZStack {
                // Background circle
                Circle()
                    .stroke(
                        bgCircleColor,
                        lineWidth: 30
                    )

                // Progress circle
                Circle()
                    .trim(from: 0, to: viewModel.progress)
                    .stroke(
                        //                        !viewModel.isPaused
                        //                        ? Color.blue2
                        //                        : Color.gray3,
                        progressCircleColor,
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

                ButtonWSound("End") {
                    viewModel.finishExercise()
                    dismiss()
                }
            }
        }
        .onAppear {
            viewModel.attachWatchConnectivityManager(watchConnectivityManager)
            viewModel.startMonitoring()
        }
        .onDisappear {
            viewModel.stopMonitoring()
        }
    }
}

#Preview {
    do {
        // Create an in-memory model container for preview
        let config = ModelConfiguration(isStoredInMemoryOnly: true)

        let container = try ModelContainer(
            for: ExerciseRecord.self,
            Weekly.self,
            configurations: config
        )

        // Create a sample exercise
        let exercise = Exercise(
            id: 1,
            name: "Brisk walking",
            imageName: "brisk-walking",
            location: .outdoor,
            needsTutorial: false,
            equipment: .none,
            weather: .clear
        )

        // Create a sample exercise record
        let record = ExerciseRecord(
            exercise: exercise,
            requiredMinutes: 0
        )

        return RecordView(record: record, modelContext: container.mainContext)
            .modelContainer(container)
            .environmentObject(WatchConnectivityManager())
        // use container safely here
    } catch {
        return Text("No")
    }
}
