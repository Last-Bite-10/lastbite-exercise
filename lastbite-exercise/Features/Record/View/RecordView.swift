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

struct RecordView: View {
    @StateObject private var healthKitManager = HealthKitManager()
    @State private var progress: CGFloat = 1.0
    @State private var activeTimeRemaining: Int
    @State private var timeRecorded: Int = 0
    @State private var isPaused: Bool = true
    @State private var isBPMUnder: Bool = false
    @State private var cancellables = Set<AnyCancellable>()
    @State private var timerCancellable: AnyCancellable?

    let totalTime: Int

    func handleFinishExercise() {
        // Stop the timer
        timerCancellable?.cancel()
        timerCancellable = nil
        
        // Stop heart rate monitoring
        healthKitManager.stopWatchHeartRateMonitoring()
        
        // TODO: Save workout data or navigate away
        // You might want to save the workout here or dismiss the view
    }

    func handlePauseExercise() {
        isPaused.toggle()
        
        if isPaused {
            // Pause: cancel the timer
            timerCancellable?.cancel()
            timerCancellable = nil
        } else {
            // Resume: restart the timer
            startTimer()
        }
    }
    
    func startTimer() {
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                guard activeTimeRemaining > 0 else {
                    handleFinishExercise()
                    return
                }

                timeRecorded += 1
                if !isBPMUnder {
                    activeTimeRemaining -= 1
                }
                progress = CGFloat(activeTimeRemaining) / CGFloat(totalTime)
            }
    }

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
                RecordPlayButton(title: isPaused ? "Start" : "Pause") {
                    handlePauseExercise()
                }

                Button("End") {
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
            // Clean up timer
            timerCancellable?.cancel()
            timerCancellable = nil
            
            // Stop heart rate monitoring
            healthKitManager.stopWatchHeartRateMonitoring()
            
            // Clear subscriptions
            cancellables.removeAll()
        }
    }
}

#Preview {
    RecordView(totalTime: 300)
}
