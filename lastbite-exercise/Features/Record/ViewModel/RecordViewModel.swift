//
//  RecordViewModel.swift
//  Exa
//
//  Created by [Your Name] on [Date]
//

import Combine
import SwiftData
import UIKit
import WatchConnectivity

@MainActor
class RecordViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var timer: TimerService

    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let healthKitManager: HealthKitManager
    var watchConnectivityManager: WatchConnectivityManager?
    private let record: ExerciseRecord
    private var context: ModelContext
    private let bpmThreshold: Double
    
//    private let timerCancellable: TimerService

    // MARK: - Initialization
    init(
        record: ExerciseRecord,
        healthKitManager: HealthKitManager,
        modelContext: ModelContext,
        watchConnectivityManager: WatchConnectivityManager
    ) {
        self.record = record
        self.healthKitManager = healthKitManager
        self.context = modelContext
        self.bpmThreshold = Double(healthKitManager.bpmThreshold)
        
        self.timer = TimerService(activeTime: record.requiredMinutes * 60, totalTime: 0, exerciseRecord: record, healthKitManager: healthKitManager, watchConnectivityManager: watchConnectivityManager)
        
        self.setupProgressSync()
        // Start observing changes to send to Watch
    }

    func attachWatchConnectivityManager(_ manager: WatchConnectivityManager) {
        self.watchConnectivityManager = manager
        subscribeToBPMUpdates(manager)
    }

    // MARK: - Watch Connectivity
    private func setupProgressSync() {
        // Send progress updates to Watch whenever they change
        Publishers.CombineLatest4(
            timer.$progress,
            timer.$totalTime,
            timer.$remainingTime,
            timer.$timerStatus,
        )
        .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
        .sink { [weak self] progress, timeRemaining, timeRecorded, timerStatus in
            self?.sendProgressToWatch(
                progress: progress,
                timeRemaining: timeRemaining,
                totalDuration: timeRecorded,
                timerStatus: timerStatus
            )
        }
        .store(in: &cancellables)
    }

    private func sendProgressToWatch(
        progress: CGFloat,
        timeRemaining: Int,
        totalDuration: Int,
        timerStatus: TimerStatusType
    ) {
        guard WCSession.default.activationState == .activated else { return }

        let progressData: [String: Any] = [
            "type": PayloadType.timerChange.rawValue,
            "data": [
                "progress": Double(progress),
                "timeRemaining": timeRemaining,
                "totalDuration": totalDuration,
                "timerStatus": timerStatus.rawValue
            ]
        ]

        // Use application context for state sync (most reliable)
        do {
            try WCSession.default.updateApplicationContext(progressData)
            print("[iPhone] Sending application context to Watch.")
        } catch {
            print(
                "Failed to update application context: \(error.localizedDescription)"
            )
        }

        // Also send as message if Watch is reachable (faster)
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(progressData, replyHandler: nil) {
                error in
                print(
                    "Failed to send progress message: \(error.localizedDescription)"
                )
            }
            
            print("[iPhone] Sending payload to Watch.")
        }
    }

    // MARK: - Public Methods
    func startMonitoring() {
        // Start Watch heart rate monitoring
        watchConnectivityManager?.startWatchHeartRateMonitoring()

        print(
            "Started monitoring - Watch: \(watchConnectivityManager?.isReceivingFromWatch ?? false), iPhone HealthKit active"
        )
    }

    func stopMonitoring() {
        cleanup()
    }

    func togglePause() {
        if timer.timerStatus != .timerPaused {
            pauseTimer()
        } else {
            startTimer()
        }

        self.timer.handleTimerStatusChange()
    }

    func finishExercise() {
        cleanup()

        // Update the record with recorded time
        let recordedMinutes = timer.activeTime / 60
        record.recordedMinutes += recordedMinutes
        record.isCompleted = recordedMinutes >= record.requiredMinutes
        if record.isCompleted {
            record.completedAt = Date()
        }

        // Save the changes to the model context
        try? context.save()

        if let exerciseName = record.exercise?.name {
            print(
                "Exercise finished: \(exerciseName), recorded: \(recordedMinutes) minutes"
            )
        } else {
            print("Exercise finished: recorded: \(recordedMinutes) minutes")
        }
    }

    // MARK: - Private Methods
    func startTimer() {
        print("Start Timer initiated")
        self.setupProgressSync()
        self.watchConnectivityManager?.startWatchHeartRateMonitoring()
        self.timer.startTimer()
    }
    
    func pauseTimer() {
        self.timer.pauseTimer()
    }

//    private func handleTimerStatusChange() {
//        self.timer.
//    }
//
//    private func handleTimerTick() {
//        self.timer.
//    }

    private func subscribeToBPMUpdates(_ manager: WatchConnectivityManager) {
        manager.bpmPublisher
            .sink { [weak self] bpm in
                print("[iPhone] BPM updated! Subscribed function triggered.")
                self?.handleBPMUpdate(bpm)
            }
            .store(in: &cancellables)
    }

    private func handleBPMUpdate(_ bpm: Double) {
//        let wasUnder: Bool = timer.timerStatus == .timerBelowBPM
        timer.handleTimerStatusChange()

        // Trigger haptic feedback when BPM drops below threshold
        if timer.timerStatus == .timerBelowBPM {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
    }

    private func cleanup() {
        timer.stopTimer()
        watchConnectivityManager?.stopWatchHeartRateMonitoring()
        cancellables.removeAll()
    }

    // MARK: - Computed Properties
    var activeTimeFormatted: String {
        formatTime(duration: abs(timer.remainingTime))
    }

    var totalTimeFormatted: String {
        formatTime(duration: timer.activeTime)
    }

//    var currentBPM: Int? {
//        guard let bpm = watchConnectivityManager?.latestBPM else {
//            return nil
//        }
//        return Int(bpm)
//    }

    var isReceivingFromWatch: Bool {
        watchConnectivityManager?.isReceivingFromWatch ?? false
    }
}

// MARK: - Helper Functions
private func formatTime(duration: Int) -> String {
    return
        "\(String(format: "%02d", duration / 60)):\(String(format: "%02d", duration % 60))"
}
