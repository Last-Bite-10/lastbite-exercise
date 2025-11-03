//
//  RecordViewModel.swift
//  Exa
//
//  Created by [Your Name] on [Date]
//

import SwiftUI
import Combine

//// TODO: change struct with real data structure of Workouts
//struct RecordModel {
//    let time: Float
//    let date: Date
//    let sportType: String
//}

@MainActor
class RecordViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var progress: CGFloat = 1.0
    @Published var activeTimeRemaining: Int
    @Published var timeRecorded: Int = 0
    @Published var isPaused: Bool = true
    @Published var isBPMUnder: Bool = false
    @Published var timerStatus: TimerStatus = .timerPaused
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private var timerCancellable: AnyCancellable?
    private let healthKitManager: HealthKitManager
    private let record: ExerciseRecord
    
    // TODO: BPM should be dynamically set based on user's age
    private let bpmThreshold: Double = 100.0
    
    // MARK: - Initialization
    init(record: ExerciseRecord, healthKitManager: HealthKitManager) {
        self.record = record
        self.activeTimeRemaining = record.requiredMinutes * 60
        self.healthKitManager = healthKitManager
    }
    
    // MARK: - Public Methods
    func startMonitoring() {
        healthKitManager.startWatchHeartRateMonitoring()
        subscribeToBPMUpdates()
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
    }
    
    func finishExercise() {
        cleanup()
        
//        let storedRecord: RecordModel = RecordModel(
//            time: Float(self.timeRecorded),
//            date: Date(),
//            sportType: "Bicycling"
//        )
        
        // Update the record with recorded time
        let recordedMinutes = timeRecorded / 60
        record.recordedMinutes += recordedMinutes
        record.isCompleted = recordedMinutes >= record.requiredMinutes
        if(record.isCompleted){
            record.completedAt = Date()
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
    
    private func handleTimerTick() {
        guard activeTimeRemaining > 0 else {
            finishExercise()
            return
        }
        
        timeRecorded += 1
        if !isBPMUnder {
            activeTimeRemaining -= 1
        }
        progress = CGFloat(activeTimeRemaining) / CGFloat(record.requiredMinutes * 60)
    }
    
    private func pauseTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
        timerStatus = .timerPaused
    }
    
    private func resumeTimer() {
        startTimer()
    }
    
    private func subscribeToBPMUpdates() {
        healthKitManager.bpmPublisher
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
        cancellables.removeAll()
    }
    
    // MARK: - Computed Properties
    var activeTimeFormatted: String {
        formatTime(duration: activeTimeRemaining)
    }
    
    var totalTimeFormatted: String {
        formatTime(duration: timeRecorded)
    }
    
    var currentBPM: Int? {
        guard let bpm = healthKitManager.latestBPM else { return nil }
        return Int(bpm)
    }
    
    var isReceivingFromWatch: Bool {
        healthKitManager.isReceivingFromWatch
    }
}

// MARK: - Helper Functions
private func formatTime(duration: Int) -> String {
    return "\(String(format: "%02d", duration / 60)):\(String(format: "%02d", duration % 60))"
}
