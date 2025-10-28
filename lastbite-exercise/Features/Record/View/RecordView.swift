//
//  HealthKitView.swift
//  Exa
//
//  Created by Ammar Alifian Fahdan on 20/10/25.
//

import SwiftUI
import HealthKit
import Combine

func formatTime(duration: Int) -> String {
    return "\(String(format: "%02d", duration / 60)):\(String(format: "%02d", duration % 60))"
}

struct HealthKitView: View {
    @StateObject private var healthKitManager = HealthKitManager()
    @State private var progress: CGFloat = 1.0
    @State private var activeTimeRemaining: Int
    @State private var timeRecorded: Int = 0
    @State private var isPaused: Bool = false
    @State private var isBPMUnder: Bool = false
    @State private var cancellables = Set<AnyCancellable>()

    let totalTime: Int
    let activeTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    func handleFinishExercise() {
        healthKitManager.stopWatchHeartRateMonitoring()
    }

    func handlePauseExercise() {}

    init(totalTime: Int) {
        self.totalTime = totalTime
        _activeTimeRemaining = State(initialValue: totalTime)
    }

    var body: some View {
        VStack {
            ZStack {
                // Background circle
                Circle()
                    .stroke(Color.accentColor.opacity(0.2), lineWidth: 30)

                // Progress circle
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.blue2, style: StrokeStyle(lineWidth: 30, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: progress)

                VStack {
                    VStack {
                        Text("Active Time")
                        Text(formatTime(duration: activeTimeRemaining))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }.padding(.bottom, 12)

                    VStack {
                        Text("BPM")

                        if let bpm = healthKitManager.latestBPM {
                            Text("\(Int(bpm))")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(
                                    isBPMUnder ? Color.red : Color.black
                                )
                        } else {
                            Text("--")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        
                        if healthKitManager.isReceivingFromWatch {
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

                Text(formatTime(duration: timeRecorded)).font(.title).fontWeight(.bold)
            }
            .padding(.vertical, 36)

            VStack {
                RecordPlayButton(title: "Pause") {
                    handlePauseExercise()
                }

                RecordPlayButton(title: "End") {
                    handleFinishExercise()
                }
            }
        }
        .onAppear {
            // Start receiving BPM from Watch
            healthKitManager.startWatchHeartRateMonitoring()
            
            // Subscribe to BPM updates
            healthKitManager.bpmPublisher
                .sink { bpm in
                    let BPMThreshold = 100.0
                    isBPMUnder = bpm < BPMThreshold
                    
                    if isBPMUnder {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                    }
                }
                .store(in: &cancellables)
        }
        .onDisappear {
            healthKitManager.stopWatchHeartRateMonitoring()
            cancellables.removeAll()
        }
        .onReceive(activeTimer) { _ in
            guard activeTimeRemaining > 0 else { return }

            timeRecorded += 1
            if !isBPMUnder {
                activeTimeRemaining -= 1
            }
            progress = CGFloat(activeTimeRemaining) / CGFloat(totalTime)
        }
    }
}

#Preview {
    HealthKitView(totalTime: 300)
}
