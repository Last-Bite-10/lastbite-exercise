//
//  TimerViewModel.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

import ActivityKit
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

    func startRecordTimer(send: Bool = true) {
        guard let timerService, let record else { return }

        healthKitService.startWorkout()

        if send {
            connectivityService.sendRecordTimerStatus(
                .timerStarted,
                for: record
            )
        }

        timerService.startTimer()
        //        startLiveActivity(for: entry)
    }

    func pauseRecordTimer(send: Bool = true) {
        guard let timerService, let record else { return }

        healthKitService.pauseWorkout()
        if send {
            connectivityService.sendRecordTimerStatus(.timerPaused, for: record)
        }
        timerService.stopTimer()
        record.recordedSeconds = timerService.activeTime
        //        updateLiveActivity(for: entry)
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
        //        endLiveActivity(for: entry)
        try? modelContext?.save()

    }

    func receiveHeartRate(_ heartRate: Int) {
        self.heartRate = heartRate
        self.timerService?.handleHeartRateChange(heartRate)
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

    // MARK: - Live Activity
    //
    //    func requestLiveActivityAuthorization() async {
    //        let authorized = ActivityAuthorizationInfo().areActivitiesEnabled
    //        if !authorized {
    //            Debugging.debug("Live Activities are not authorized.")
    //        }
    //    }
    //
    //    private func startLiveActivity(for entry: TimerEntry) {
    //        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
    //            Debugging.debug("Live Activities not enabled/authorized.")
    //            return
    //        }
    //
    //        guard let startDate = entry.startDate else { return }
    //        let endDate = startDate.addingTimeInterval(entry.targetDuration)
    //
    //        let attributes = TimerActivityAttributes(entryId: entry.id.uuidString)
    //        let initialState = TimerActivityAttributes.ContentState(
    //            remainingTime: entry.remainingTime,
    //            entryTitle: entry.title,
    //            isPaused: false,
    //            currentHeartRate: entry.currentHeartRate,
    //            endDate: endDate
    //        )
    //
    //        do {
    //            activity = try Activity<TimerActivityAttributes>.request(
    //                attributes: attributes,
    //                content: ActivityContent(state: initialState, staleDate: nil),
    //                pushType: nil
    //            )
    //            Debugging.debug(
    //                "✅ Started Live Activity: \(String(describing: activity?.id))"
    //            )
    //        } catch {
    //            Debugging.debug("❌ Failed to start Live Activity: \(error)")
    //        }
    //    }
    //
    //    private func updateLiveActivity(for entry: TimerEntry) {
    //        guard let activity else { return }
    //
    //        let endDate: Date
    //        if let startDate = entry.startDate {
    //            endDate = startDate.addingTimeInterval(entry.targetDuration)
    //        } else {
    //            endDate = Date().addingTimeInterval(entry.remainingTime)
    //        }
    //
    //        let updatedState = TimerActivityAttributes.ContentState(
    //            remainingTime: entry.remainingTime,
    //            entryTitle: entry.title,
    //            isPaused: entry.timerState == .paused,
    //            currentHeartRate: entry.currentHeartRate,
    //            endDate: endDate
    //        )
    //
    //        Task {
    //            await activity.update(
    //                ActivityContent(state: updatedState, staleDate: nil)
    //            )
    //        }
    //    }
    //
    //    private func endLiveActivity(for entry: TimerEntry) {
    //        guard let activity else { return }
    //
    //        let finalState = TimerActivityAttributes.ContentState(
    //            remainingTime: 0,
    //            entryTitle: entry.title,
    //            isPaused: false,
    //            currentHeartRate: entry.currentHeartRate,
    //            endDate: Date()
    //        )
    //
    //        Task {
    //            await activity.end(
    //                ActivityContent(state: finalState, staleDate: nil),
    //                dismissalPolicy: .immediate
    //            )
    //            Debugging.debug("✅ Ended Live Activity")
    //        }
    //
    //        self.activity = nil
    //    }
}
