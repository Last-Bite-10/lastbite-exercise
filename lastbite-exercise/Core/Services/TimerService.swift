//
//  TimerService.swift
//  lastbite-exercise
//
//  Created by Ammar Alifian Fahdan on 13/11/25.

import Combine
import Foundation

@MainActor
class TimerService: ObservableObject {  // ← Add ObservableObject conformance
    // Properties
    @Published var progress: Double
    @Published var activeTime: Int
    @Published var remainingTime: Int
    @Published var totalTime: Int
    @Published var timerStatus: TimerStatusType
    @Published var exerciseRecord: ExerciseRecord

    var timer: AnyCancellable?

    // Used services
    var healthKitManager: HealthKitManager
    var watchConnectivityManager: WatchConnectivityManager

    // MARK: - Initialization
    init(
        activeTime: Int,
        totalTime: Int,
        exerciseRecord: ExerciseRecord,
        healthKitManager: HealthKitManager,
        watchConnectivityManager: WatchConnectivityManager
    ) {
        self.progress = exerciseRecord.recordedSeconds > 0
            ? TimerService.getProgressPercentage(
                remainingTime: max(0, exerciseRecord.requiredSeconds - exerciseRecord.recordedSeconds),
                exerciseRecord: exerciseRecord
            )
            : 1.0
        self.activeTime = exerciseRecord.recordedSeconds
        self.totalTime = totalTime
        self.remainingTime = max(0, exerciseRecord.requiredSeconds - exerciseRecord.recordedSeconds)
        self.timerStatus = .timerStopped
        self.exerciseRecord = exerciseRecord

        self.healthKitManager = healthKitManager
        self.watchConnectivityManager = watchConnectivityManager
    }

    // MARK: - Core Functions
    func startTimer() {
        print("Timer started.")
        guard timer == nil else { return }
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.handleTimerTick()
            }
        timerStatus = .timerStarted
    }

    func pauseTimer() {
        timer?.cancel()
        timer = nil
        timerStatus = .timerPaused
    }

    func stopTimer() {
        timer?.cancel()
        timer = nil
        timerStatus = .timerStopped
    }

    // MARK: - Internal Functions
    private func handleTimerTick() {
        if timerStatus != .timerBelowBPM {
            self.activeTime += 1
            self.remainingTime -= 1
        }

        self.totalTime += 1
        handleTimerStatusChange()

        // Update progress based on active time
        progress = TimerService.getProgressPercentage(remainingTime: remainingTime, exerciseRecord: exerciseRecord)
        
        print("Timer ticked!! Timer now : \(self.totalTime) \(self.timerStatus) \(self.activeTime) \(self.remainingTime) \(self.progress)")
    }

    func handleTimerStatusChange() {
        if remainingTime < 0 {
            timerStatus = .timerOverflown
            return
        }

        if let bpm = watchConnectivityManager.latestBPM,
            bpm < Double(healthKitManager.bpmThreshold)
        {
            timerStatus = .timerBelowBPM
            return
        }

        timerStatus = .timerStarted
    }

    // MARK: - Utility Functions
    static func getProgressPercentage(
        remainingTime: Int,
        exerciseRecord: ExerciseRecord
    ) -> Double {
        // Implement your progress calculation here
        return min(
            Double(remainingTime) / Double(exerciseRecord.requiredSeconds),
            1.0
        )
    }
}
