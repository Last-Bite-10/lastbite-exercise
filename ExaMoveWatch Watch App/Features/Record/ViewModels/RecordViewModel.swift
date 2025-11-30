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
    //    private var activity: Activity<TimerActivityAttributes>?

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

        setupConnectivityObservers()
    }

    func setup(_ context: ModelContext, for record: ExerciseRecord) {
        self.modelContext = context
        self.record = record
        self.timerService = TimerService(
            record: record,
            healthKitService: healthKitService,
            connectivityService: connectivityService
        )
    }

    // MARK: Send Function
    func sendSelectedRecord(_ record: ExerciseRecord) {
        connectivityService.sendSelectedRecord(record)
    }

    func startRecordTimer() {
        guard let timerService else { return }

        healthKitService.startWorkout { heartRate in
            Task { @MainActor in
                self.heartRate = heartRate
                self.connectivityService.sendHeartRate(heartRate)
            }
        }
        connectivityService.sendRecordTimerStatus(.timerStarted)
        timerService.startTimer()
        //        startLiveActivity(for: entry)
        try? modelContext?.save()
    }

    func pauseRecordTimer() {
        guard let timerService, let record else { return }

        healthKitService.stopWorkout()
        connectivityService.sendRecordTimerStatus(.timerPaused)
        timerService.stopTimer()
        record.recordedSeconds = timerService.activeTime
        //        updateLiveActivity(for: entry)
        try? modelContext?.save()
    }

    func endRecordTimer() {
        guard let timerService, let record else { return }

        healthKitService.stopWorkout()
        connectivityService.sendRecordTimerStatus(.timerStopped)
        timerService.stopTimer()
        record.recordedSeconds = timerService.activeTime
        //        endLiveActivity(for: entry)
        try? modelContext?.save()

    }

    // MARK: - Connectivity
    private func setupConnectivityObservers() {
        connectivityService.onRecordTimerUpdate = {
            [weak self] status in
            Task { @MainActor in
                self?.timerService?.handleTimerStatusChange(status)
            }
        }

        connectivityService.onHeartRateUpdate = {
            [weak self] heartRate in
            Task { @MainActor in
                self?.heartRate = heartRate
                self?.timerService?.handleHeartRateChange(heartRate)
            }
        }
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
