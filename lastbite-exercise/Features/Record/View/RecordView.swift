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
    @State private var viewModel: RecordViewModel?
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    private let record: ExerciseRecord
    private let context: ModelContext

    var bgCircleColor: Color {
        guard let viewModel = viewModel else { return Color.cardGray.opacity(1) }
        switch viewModel.timer.timerStatus {
        case .timerBelowBPM: return Color.cardGray.opacity(1)
        case .timerPaused: return Color.cardGray.opacity(1)
        case .timerStarted: return Color.accentColor.opacity(0.2)
        case .timerStopped: return Color.cardGray.opacity(1)
        case .timerOverflown: return Color.purple2.opacity(1)
        }
    }

    var progressCircleColor: Color {
        guard let viewModel = viewModel else { return Color.pausedGray.opacity(1) }
        switch viewModel.timer.timerStatus {
        case .timerBelowBPM: return Color.pausedGray.opacity(1)
        case .timerPaused: return Color.pausedGray.opacity(1)
        case .timerStarted: return Color.blueTwo.opacity(1)
        case .timerStopped: return Color.pausedGray.opacity(1)
        case .timerOverflown: return Color.purple2.opacity(1)
        }
    }

    var timerMessage: LocalizedStringKey {
        switch viewModel?.timer.timerStatus {
        case .timerPaused:
            return "The time is paused. Continue by increasing your BPM!"
        case .timerStarted:
            return
                "Your exercise is in progress, your heartbeat is being recorded!"
        case .timerStopped:
            return "Start now! Remember only your active time **(BPM >= \(healthKitManager.bpmThreshold))** will be recorded."
        case .timerOverflown:
            return
                "Your exercise is in progress, your heartbeat is being recorded!"
        case .timerBelowBPM:
            return "The time is paused. Continue by increasing your BPM!"
        default:
            return "ViewModel not initialized yet."
        }
    }

    init(record: ExerciseRecord, modelContext: ModelContext) {
        self.record = record
        self.context = modelContext
    }

    var body: some View {
        Group {
            if let viewModel = viewModel {
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
                            .trim(from: 0, to: viewModel.timer.progress)
                            .stroke(
                                progressCircleColor,
                                style: StrokeStyle(lineWidth: 30, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                            .animation(
                                .easeInOut(duration: 0.5),
                                value: viewModel.timer.progress
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

                                if let bpm = watchConnectivityManager.latestBPM {
                                    Text("\(Int(bpm))")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundStyle(
                                            viewModel.timer.timerStatus == .timerBelowBPM
                                                ? Color.red : Color.black
                                        )
                                } else {
                                    Text("--")
                                        .font(.title)
                                        .fontWeight(.bold)
                                }

                                if watchConnectivityManager.latestBPM != nil {
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

                        Text("\(viewModel.timer.remainingTime > 0 ? "" : "+")\(viewModel.totalTimeFormatted)").font(.title).fontWeight(
                            .bold
                        )
                    }
                    .padding(.vertical, 36)

                    VStack {
                        RecordPlayButton(title: viewModel.timer.timerStatus != .timerPaused ? "Start" : "Pause")
                        {
                            viewModel.togglePause()
                        }

                        Button("End") {
                            viewModel.finishExercise()
                            dismiss()
                        }
                    }
                }
            } else {
                ProgressView()
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = RecordViewModel(
                    record: record,
                    healthKitManager: healthKitManager,
                    modelContext: context,
                    watchConnectivityManager: watchConnectivityManager
                )
            }
            viewModel?.startMonitoring()
        }
        .onDisappear {
            viewModel?.stopMonitoring()
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
