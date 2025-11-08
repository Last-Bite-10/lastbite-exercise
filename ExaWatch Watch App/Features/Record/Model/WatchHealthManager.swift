//
//  WatchHealthManager.swift
//  ExaWatch Watch App
//
//  Created by Ammar Alifian Fahdan on 27/10/25.
//  Updated for real-time HR streaming.
//

import HealthKit
import WatchConnectivity
import SwiftUI
import Combine

enum PayloadType {
    case timerChange
    case bpmChange
}

enum TimerStatus: String, Codable, Hashable, CaseIterable {
    case timerPaused = "timer_paused"
    case timerStarted = "timer_started"
    case timerStopped = "timer_stopped"
    case timerOverflown = "timer_overflown"
    case timerBelowBPM = "timer_below_bpm"
}

class WatchHealthManager: NSObject, ObservableObject, WCSessionDelegate, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {

    @Published var heartRate: Double = 0.0
    @Published var receivedProgress: ProgressData?

    private let healthStore = HKHealthStore()

    private var workoutSession: HKWorkoutSession?
    private var workoutBuilder: HKLiveWorkoutBuilder?

    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
            print("[iOS] WCSession started from WatchHealthManager")
        }
    }

    // MARK: - HealthKit Authorization
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }

        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.workoutType()
        ]

        let typesToShare: Set = [HKObjectType.workoutType()]

        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            if !success {
                print("HealthKit auth failed:", error?.localizedDescription ?? "")
            }
        }
    }

    // MARK: - Real-Time Streaming
    func startStreaming() {
        let config = HKWorkoutConfiguration()
        config.activityType = .other
        config.locationType = .unknown

        do {
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: config)
            workoutBuilder = workoutSession!.associatedWorkoutBuilder()

            workoutBuilder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: config)

            workoutSession?.delegate = self
            workoutBuilder?.delegate = self

            workoutSession?.startActivity(with: Date())
            workoutBuilder?.beginCollection(withStart: Date()) { _, _ in }

        } catch {
            print("Workout session failed:", error.localizedDescription)
        }
    }

    func stopStreaming() {
        workoutSession?.stopActivity(with: Date())
        workoutSession?.end()
        workoutSession = nil
        workoutBuilder = nil
    }

    // MARK: - HKLiveWorkoutBuilder Delegate
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf types: Set<HKSampleType>) {
        guard let hrType = HKQuantityType.quantityType(forIdentifier: .heartRate),
              types.contains(hrType),
              let stats = workoutBuilder.statistics(for: hrType),
              let quantity = stats.mostRecentQuantity() else { return }

        let bpm = quantity.doubleValue(for: HKUnit(from: "count/min"))

        DispatchQueue.main.async { self.heartRate = bpm }

        sendBPMToiPhone(bpm)
    }

    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) { }

    // MARK: - HKWorkoutSession Delegate
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState, date: Date) {
        // Optional log
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("Workout session failed:", error.localizedDescription)
    }

    // MARK: - iPhone Communication
    private func sendBPMToiPhone(_ bpm: Double) {
        let message: [String: Any] = ["bpm": bpm, "timestamp": Date().timeIntervalSince1970]

        if WCSession.default.isReachable {
            WCSession.default.sendMessage(message, replyHandler: nil) { error in
                print("Failed to send BPM via message:", error.localizedDescription)
            }
            
            print("Transmitted \(message)")
        }

        WCSession.default.transferUserInfo(message)
    }
    
    func sendSignalToiPhone(timerStatus: TimerStatus) {
        let message: [String: Any] = ["status": timerStatus.rawValue]
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(message, replyHandler: nil) { error in
                print("Failed to send BPM via message:", error.localizedDescription)
            }
            
            print("[Watch] Transmitted \(message)")
        }
    }

    // MARK: - WCSession Delegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation error:", error.localizedDescription)
        } else {
            print("Watch WCSession activated")
        }
    }


    // MARK: Handle received data from iPhone
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if message["command"] as? String == "start" {
            print("[Watch] Start received.")
            DispatchQueue.main.async {
                self.requestAuthorization()
                self.startStreaming()
            }
        } else if message["command"] as? String == "stop" {
            print("[Watch] Stop received.")
            DispatchQueue.main.async {
//                self.stopStreaming()
            }
        }

        if let progressValue = message["progress"] as? Double,
           let isPaused = message["isPaused"] as? Bool,
           let timeRemaining = message["timeRemaining"] as? Int,
           let totalDuration = message["totalDuration"] as? Int {

            DispatchQueue.main.async {
                self.receivedProgress = ProgressData(
                    progress: CGFloat(progressValue),
                    isPaused: isPaused,
                    timeRemaining: timeRemaining,
                    totalDuration: totalDuration
                )
            }
        }
    }

    // MARK: Handle fallback in case of disconnect
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if let progressValue = applicationContext["progress"] as? Double,
           let isPaused = applicationContext["isPaused"] as? Bool,
           let timeRemaining = applicationContext["timeRemaining"] as? Int,
           let totalDuration = applicationContext["totalDuration"] as? Int {

            DispatchQueue.main.async {
                self.receivedProgress = ProgressData(
                    progress: CGFloat(progressValue),
                    isPaused: isPaused,
                    timeRemaining: timeRemaining,
                    totalDuration: totalDuration
                )
            }
        }
    }
}
