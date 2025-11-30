//
//  TimerViewModel.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

import Combine
import Foundation
import SwiftData

@MainActor @Observable
final class RecordViewModel {
    private let healthKitService: HealthKitService
    private let connectivityService: WCService

    private var modelContext: ModelContext?

    var record: ExerciseRecord?
    var timerService: TimerService?
    var heartRate: Int?
    var bpmTreshold: Int

    // MARK: - Setup
    init(healthKitService: HealthKitService, connectivityService: WCService) {
        self.healthKitService = healthKitService
        self.connectivityService = connectivityService
        self.bpmTreshold = healthKitService.bpmThreshold

        healthKitService.requestAuthorization()
    }

    func setup(_ context: ModelContext, for record: ExerciseRecord) {
        self.modelContext = context
        self.record = record
        self.timerService = TimerService(
            record: record,
            healthKitService: healthKitService,
            connectivityService: connectivityService
        )
        Debugging.debug("Record view model setup successfully")
    }

    func startRecordTimer(send: Bool = true) {
        guard let timerService, let record else { return }

        healthKitService.startWorkout { heartRate in
            Task { @MainActor in
                self.heartRate = heartRate
                self.connectivityService.sendHeartRate(heartRate)
            }
        }
        if send {
            connectivityService.sendRecordTimerStatus(
                .timerStarted,
                for: record
            )
        }
        timerService.startTimer()
    }

    func pauseRecordTimer(send: Bool = true) {
        guard let timerService, let record else { return }

        healthKitService.pauseWorkout()
        if send {
            connectivityService.sendRecordTimerStatus(.timerPaused, for: record)
        }
        timerService.stopTimer()
        record.recordedSeconds = timerService.activeTime

        try? modelContext?.save()
    }

    func endRecordTimer(send: Bool = true) {
        guard let timerService, let record else { return }

        healthKitService.stopWorkout()
        if send {
            connectivityService.sendRecordTimerStatus(
                .timerStopped,
                for: record
            )
        }
        timerService.stopTimer()
        record.recordedSeconds = timerService.activeTime

        try? modelContext?.save()
    }

    // MARK: - Helper Functions
    private func formatTime(duration: TimeInterval) -> String {
        let totalSeconds = Int(duration.rounded())
        let minutes = (totalSeconds / 60)
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    // MARK: - Computed Properties
    var remainingTimeFormatted: String {
        return formatTime(duration: timerService?.remainingTime ?? 0)
    }

    var totalTimeFormatted: String {
        Debugging.debug("Total time : \(timerService?.totalTime ?? 0)")
        return formatTime(duration: timerService?.totalTime ?? 0)
    }

    var isReceivingFromWatch: Bool {
        connectivityService.isReceivingFromWatch
    }
}
