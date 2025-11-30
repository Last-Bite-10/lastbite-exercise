//
//  TimerService.swift
//  lastbite-exercise
//
//  Created by Ammar Alifian Fahdan on 13/11/25.

import Combine
import Foundation

enum TimerStatus: String, Codable, Hashable, CaseIterable {
    case timerPaused
    case timerStarted
    case timerStopped
    case timerOverflown
    case timerBelowBPM
}

@MainActor @Observable
final class TimerService {
    // Properties
    var record: ExerciseRecord
    var activeTime: TimeInterval
    var totalTime: TimeInterval
    var remainingTime: TimeInterval
    var timerStatus: TimerStatus
    var timer: AnyCancellable?

    // Used Services
    private var healthKitService: HealthKitService
    private var connectivityService: WCService

    // getter
    var progress: Double {
        return min(
            remainingTime / record.requiredSeconds,
            1.0
        )
    }

    // MARK: - Initialization
    init(
        record: ExerciseRecord,
        healthKitService: HealthKitService,
        connectivityService: WCService,
    ) {
        self.record = record
        self.activeTime = record.recordedSeconds
        self.totalTime = record.recordedSeconds
        self.remainingTime = max(
            0,
            record.requiredSeconds - record.recordedSeconds
        )
        self.timerStatus = .timerStopped
        self.healthKitService = healthKitService
        self.connectivityService = connectivityService
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

    // MARK: - Internal Functions
    private func handleTimerTick() {
        if timerStatus != .timerBelowBPM {
            self.activeTime += 1
            self.remainingTime -= 1
        }

        self.totalTime += 1
        handleTimerStatusChange(.timerStarted)

        Debugging.debug(
            "Timer ticked!! Timer now : \(self.totalTime) \(self.timerStatus) \(self.activeTime) \(self.remainingTime) \(self.progress)"
        )
    }

    // MARK: - Utility Functions
    private static func getProgressPercentage(_ record: ExerciseRecord)
        -> Double
    {
        let remainingTime = max(
            0,
            record.requiredSeconds - record.recordedSeconds
        )

        return min(
            remainingTime / record.requiredSeconds,
            1.0
        )
    }
}
