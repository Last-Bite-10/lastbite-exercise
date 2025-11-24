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

struct RecordContentView: View {
    @ObservedObject var viewModel: RecordViewModel
    @ObservedObject var watchConnectivityManager: WatchConnectivityManager
    let healthKitManager: HealthKitManager
    let dismiss: DismissAction
    
    var bgCircleColor: Color {
        switch viewModel.timer.timerStatus {
        case .timerBelowBPM: return Color.cardGray.opacity(1)
        case .timerPaused: return Color.cardGray.opacity(1)
        case .timerStarted: return Color.accentColor.opacity(0.2)
        case .timerStopped: return Color.cardGray.opacity(1)
        case .timerOverflown: return Color.purple2.opacity(1)
        }
    }

    var progressCircleColor: Color {
        switch viewModel.timer.timerStatus {
        case .timerBelowBPM: return Color.pausedGray.opacity(1)
        case .timerPaused: return Color.pausedGray.opacity(1)
        case .timerStarted: return Color.blueTwo.opacity(1)
        case .timerStopped: return Color.pausedGray.opacity(1)
        case .timerOverflown: return Color.purple2.opacity(1)
        }
    }

    var timerMessage: LocalizedStringKey {
        switch viewModel.timer.timerStatus {
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
        }
    }
    
    var body: some View {
        VStack {
            Text(timerMessage)
                .frame(
                    width: 300,
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
                        Text("\(viewModel.timer.remainingTime < 0 ? "+" : "")\(viewModel.remainingTimeFormatted)")
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

                Text("\(viewModel.totalTimeFormatted)").font(.title).fontWeight(
                    .bold
                )
            }
            .padding(.vertical, 36)

            VStack {
                RecordPlayButton(
                    title: viewModel.timer.timerStatus == .timerPaused || viewModel.timer.timerStatus == .timerStopped
                        ? "Start"
                        : "Pause"
                )
                {
                    viewModel.togglePause()
                }

                ButtonWSound(role: nil, action: {
                    RecordSessionManager.shared.finishSession()
                    dismiss()
                }, label: {
                    Text("End").foregroundStyle(.red)
                })
            }
        }
    }
}

struct RecordView: View {
    @StateObject private var healthKitManager = HealthKitManager()
    @EnvironmentObject private var watchConnectivityManager: WatchConnectivityManager
    @StateObject private var sessionManager = RecordSessionManager.shared
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    private let record: ExerciseRecord
    

    init(record: ExerciseRecord, modelContext: ModelContext) {
        self.record = record
        self._sessionManager = StateObject(wrappedValue: RecordSessionManager.shared)
    }

    var body: some View {
        Group {
            if let viewModel = sessionManager.activeSession {
                RecordContentView(
                    viewModel: viewModel,
                    watchConnectivityManager: watchConnectivityManager,
                    healthKitManager: healthKitManager,
                    dismiss: dismiss
                )
                .onAppear {
                    viewModel.startMonitoring()
                }
            } else {
                ProgressView()
                    .onAppear {
                        // Create session using the session manager
                        let viewModel = sessionManager.startSession(
                            record: record,
                            healthKitManager: healthKitManager,
                            modelContext: modelContext,
                            watchConnectivityManager: watchConnectivityManager
                        )
                        viewModel.startMonitoring()
                    }
            }
        }
        // Note: We don't clean up on disappear anymore - session persists!
    }
}
