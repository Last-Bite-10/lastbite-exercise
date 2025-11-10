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

enum TimerStatus {
    case timerPaused
    case timerStarted
    case timerStopped
    case timerOverflown
    case timerBelowBPM
}

@MainActor
class RecordViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var progress: CGFloat = 1.0
    @Published var activeTimeRemaining: Int
    @Published var timeRecorded: Int = 0
    @Published var isPaused: Bool = true
    @Published var isBPMUnder: Bool = false
    @Published var timerStatus: TimerStatus = .timerStopped
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private var timerCancellable: AnyCancellable?
    private let healthKitManager: HealthKitManager
    private var watchConnectivityManager: WatchConnectivityManager?
    private let record: ExerciseRecord
    private var context: ModelContext
    private let bpmThreshold: Double

    // MARK: - Initialization
    init(
        record: ExerciseRecord,
        healthKitManager: HealthKitManager,
        modelContext: ModelContext
    ) {
        self.record = record
        self.activeTimeRemaining = record.requiredMinutes * 60
        self.healthKitManager = healthKitManager
        self.context = modelContext
        self.bpmThreshold = Double(healthKitManager.bpmThreshold ?? 100)

        // Start observing changes to send to Watch
        setupProgressSync()
    }

    // MARK: - Watch Connectivity
    private func setupProgressSync() {
        // Send progress updates to Watch whenever they change
        Publishers.CombineLatest4(
            $progress,
            $isPaused,
            $activeTimeRemaining,
            $timeRecorded
        )
        .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
        .sink { [weak self] progress, isPaused, timeRemaining, timeRecorded in
            self?.sendProgressToWatch(
                progress: progress,
                isPaused: isPaused,
                timeRemaining: timeRemaining,
                totalDuration: timeRecorded
            )
        }
        .store(in: &cancellables)
    }

    private func sendProgressToWatch(
        progress: CGFloat,
        isPaused: Bool,
        timeRemaining: Int,
        totalDuration: Int
    ) {
        guard WCSession.default.activationState == .activated else { return }

        let progressData: [String: Any] = [
            "progress": Double(progress),
            "isPaused": isPaused,
            "timeRemaining": timeRemaining,
            "totalDuration": totalDuration,
        ]

        // Use application context for state sync (most reliable)
        do {
            try WCSession.default.updateApplicationContext(progressData)
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
        }
    }

    // MARK: - Public Methods
    func startMonitoring() {
        // Start Watch heart rate monitoring
        healthKitManager.startWatchHeartRateMonitoring()

        // CRITICAL FIX: Also start real-time monitoring on iPhone
        // This will populate latestBPM from both Watch AND iPhone's own sensors
        healthKitManager.startRealTimeHeartRateMonitoring()

        // Subscribe to BPM updates
        subscribeToBPMUpdates()

        print(
            "Started monitoring - Watch: \(healthKitManager.isReceivingFromWatch), iPhone HealthKit active"
        )
    }

    func stopMonitoring() {
        cleanup()
    }

    func togglePause() {
        isPaused.toggle()

        if isPaused {
            pauseTimer()
        } else {
            resumeTimer()
        }

        handleTimerStatusChange()
    }

    func finishExercise() {
        cleanup()

        // Update the record with recorded time
        let recordedMinutes = timeRecorded / 60
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
    private func startTimer() {
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.handleTimerTick()
            }
        timerStatus = .timerStarted
    }

    private func handleTimerStatusChange() {
        if isPaused {
            timerStatus = .timerPaused
        } else {
            if isBPMUnder {
                timerStatus = .timerBelowBPM
            } else {
                if activeTimeRemaining < 0 {
                    timerStatus = .timerOverflown
                } else {
                    timerStatus = .timerStarted
                }
            }
        }
    }

    private func handleTimerTick() {
        if !isBPMUnder {
            activeTimeRemaining -= 1
        }

        timeRecorded += 1
        handleTimerStatusChange()

        progress = min(
            CGFloat(activeTimeRemaining) / CGFloat(record.requiredMinutes * 60),
            1
        )
    }

    private func pauseTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
        timerStatus = .timerPaused
    }

    private func resumeTimer() {
        startTimer()
        timerStatus = .timerStarted
    }
    
    private func subscribeToBPMUpdates(_ manager: WatchConnectivityManager) {
        manager.bpmPublisher
            .sink { [weak self] bpm in
                self?.handleBPMUpdate(bpm)
            }
            .store(in: &cancellables)
    }

    private func handleBPMUpdate(_ bpm: Double) {
        let wasUnder = isBPMUnder
        isBPMUnder = bpm < bpmThreshold

        // Trigger haptic feedback when BPM drops below threshold
        if isBPMUnder && !wasUnder {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
    }

    private func cleanup() {
        timerCancellable?.cancel()
        timerCancellable = nil
        healthKitManager.stopWatchHeartRateMonitoring()
        healthKitManager.stopRealTimeHeartRateMonitoring()  // CRITICAL FIX: Stop iPhone monitoring too
        cancellables.removeAll()
    }

    // MARK: - Computed Properties
    var activeTimeFormatted: String {
        formatTime(duration: abs(activeTimeRemaining))
    }

    var totalTimeFormatted: String {
        formatTime(duration: timeRecorded)
    }

    var currentBPM: Int? {
        guard let bpm = healthKitManager.latestBPM else {
            return nil
        }
        return Int(bpm)
    }

    var isReceivingFromWatch: Bool {
        watchConnectivityManager?.isReceivingFromWatch ?? false
    }
}

// MARK: - Helper Functions
private func formatTime(duration: Int) -> String {
    return
        "\(String(format: "%02d", duration / 60)):\(String(format: "%02d", duration % 60))"
}
