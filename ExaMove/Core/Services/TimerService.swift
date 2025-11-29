//
//  TimerService.swift
//  lastbite-exercise
//
//  Created by Ammar Alifian Fahdan on 13/11/25.

import Combine
import Foundation

@MainActor @Observable
class TimerService {  // ← Add ObservableObject conformance
    // Properties
    var record: ExerciseRecord
    var progress: Double
    var activeTime: TimeInterval
    var totalTime: TimeInterval = 0
    var remainingTime: TimeInterval
    var timerStatus: TimerStatus

    var timer: AnyCancellable?

    // Used services
    var healthKitService = HealthKitService.shared
    var connectivityService = WCService.shared

    // MARK: - Initialization
    init(record: ExerciseRecord) {
        self.record = record
        self.progress = TimerService.getProgressPercentage(record)
        self.activeTime = record.requiredSeconds
        self.remainingTime = max(
            0,
            record.requiredSeconds - record.recordedSeconds
        )
        self.timerStatus = .timerStopped
    }

    // MARK: - Core Functions
    func startTimer() {
        Debugging.debug("Timer started.")
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
        handleTimerStatusChange(.timerStarted)

        // Update progress based on active time
        progress = TimerService.getProgressPercentage(record)

        Debugging.debug(
            "Timer ticked!! Timer now : \(self.totalTime) \(self.timerStatus) \(self.activeTime) \(self.remainingTime) \(self.progress)"
        )
    }

    func handleTimerStatusChange(_ status: TimerStatus) {
        if remainingTime < 0 {
            timerStatus = .timerOverflown
            return
        }

        self.timerStatus = status
    }

    func handleHeartRateChange(_ heartRate: Int) {
        if heartRate < healthKitService.bpmThreshold {
            timerStatus = .timerBelowBPM
            return
        }
    }

    // MARK: - Utility Functions
    private static func getProgressPercentage(_ record: ExerciseRecord)
        -> Double
    {
        let remainingTime = max(
            record.requiredSeconds - record.recordedSeconds,
            0
        )

        return min(
            remainingTime / record.requiredSeconds,
            1.0
        )
    }
}
