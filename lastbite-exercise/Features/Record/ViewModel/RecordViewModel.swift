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
    let record: ExerciseRecord  // Changed to internal for session manager access
    private var context: ModelContext
    private let bpmThreshold: Double

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
        
        self.timer = TimerService(
            activeTime: record.requiredMinutes * 60, 
            totalTime: 0, 
            exerciseRecord: record, 
            healthKitManager: healthKitManager, 
            watchConnectivityManager: watchConnectivityManager
        )
        
        self.setupProgressSync()
        self.setupTimerObservation()
        self.attachWatchConnectivityManager(watchConnectivityManager)
        // Start observing changes to send to Watch
    }

    func attachWatchConnectivityManager(_ manager: WatchConnectivityManager) {
        // self.watchConnectivityManager = manager
        // subscribeToBPMUpdates(manager)
        subscribeToWatchTimerStatusUpdates(manager)
    }

    // MARK: - Watch Connectivity
    private func setupTimerObservation() {
        // Forward timer changes to this ViewModel's objectWillChange
        // This ensures SwiftUI views observing this ViewModel update when timer properties change
        timer.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
        .store(in: &cancellables)
    }
    
    private func setupProgressSync() {
        // Send progress updates to Watch whenever they change
        Publishers.CombineLatest4(
            timer.$progress,
            timer.$remainingTime,
            timer.$totalTime,
            timer.$timerStatus,
        )
        .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
        .sink {
            [weak self] progress, timeRemaining, timeRecorded, timerStatus in
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
        progress: Double,
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
            print("[iPhone] Sending application context to Watch. Payload : \(progressData)")
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
            
            print("[iPhone] Sending payload to Watch. Payload : \(progressData)")
        }
    }

    // MARK: - Public Methods
    func startMonitoring() {
        // Start Watch heart rate monitoring
        watchConnectivityManager?.startWatchHeartRateMonitoring()
        
        // Start HealthKit workout session for background tracking
        healthKitManager.startWorkoutSession()

        print(
            "Started monitoring - Watch: \(watchConnectivityManager?.isReceivingFromWatch ?? false), iPhone HealthKit active"
        )
    }

    func stopMonitoring() {
        cleanup()
    }

    func togglePause() {
        print("Toggle trigger")
        if timer.timerStatus != .timerPaused && timer.timerStatus != .timerStopped {
            print("Elig for pause. State now : \(timer.timerStatus)")
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
        self.healthKitManager.resumeWorkoutSession()
        self.timer.startTimer()
    }
    
    func pauseTimer() {
        self.timer.pauseTimer()
        self.healthKitManager.pauseWorkoutSession()
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
    
    private func subscribeToWatchTimerStatusUpdates(_ manager: WatchConnectivityManager) {
        manager.watchTimerStatusPublisher
            .sink { [weak self] timerStatus in
                print("[iPhone] Watch timer status updated! New status: \(timerStatus)")
                self?.handleWatchTimerStatusUpdate(timerStatus)
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
    
    private func handleWatchTimerStatusUpdate(_ watchTimerStatus: TimerStatusType) {
        // Synchronize the timer status with the watch
        // Only consider timerStopped, timerStarted, and timerPaused from the watch
        switch watchTimerStatus {
        case .timerStopped:
            print("[iPhone] Watch requested stop, pausing timer")
            pauseTimer()
        case .timerStarted:
            print("[iPhone] Watch requested start, starting timer")
            startTimer()
        case .timerPaused:
            print("[iPhone] Watch requested pause, pausing timer")
            pauseTimer()
        default:
            // Ignore other states like timerBelowBPM, timerAboveBPM as they are iPhone-driven
            print("[iPhone] Watch sent \(watchTimerStatus), ignoring as it's not a control state")
        }
    }

    private func cleanup() {
        timer.stopTimer()
        watchConnectivityManager?.stopWatchHeartRateMonitoring()
        healthKitManager.endWorkoutSession()
        cancellables.removeAll()
    }

    // MARK: - Computed Properties
    var remainingTimeFormatted: String {
        return formatTime(duration: abs(timer.remainingTime))
    }

    var totalTimeFormatted: String {
        print("Total time : \(timer.totalTime)")
        return formatTime(duration: timer.totalTime)
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
