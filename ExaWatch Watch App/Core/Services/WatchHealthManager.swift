//
//  WatchHealthManager.swift
//  ExaWatch Watch App
//
//  Created by Ammar Alifian Fahdan on 27/10/25.
//

import Combine
import HealthKit
import SwiftUI
import WatchConnectivity

@MainActor
class WatchHealthManager: NSObject, ObservableObject, WCSessionDelegate {
    @Published var heartRate: Double = 0.0
    @Published var receivedProgress: ProgressData?

    private let healthStore = HKHealthStore()
    private var heartRateQuery: HKAnchoredObjectQuery?

    static let shared = WatchHealthManager()

    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    // MARK: - HealthKit Authorization
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        let types = Set([
            HKQuantityType.quantityType(forIdentifier: .heartRate)!
        ])
        healthStore.requestAuthorization(toShare: [], read: types) {
            success,
            error in
            if !success {
                print(
                    "HealthKit auth failed:",
                    error?.localizedDescription ?? ""
                )
            }
        }
    }

    // MARK: - Heart Rate Streaming
    func startStreaming() {
        guard let type = HKQuantityType.quantityType(forIdentifier: .heartRate)
        else { return }
        heartRateQuery = HKAnchoredObjectQuery(
            type: type,
            predicate: nil,
            anchor: nil,
            limit: HKObjectQueryNoLimit
        ) {
            _,
            samples,
            _,
            _,
            _ in
            Task { @MainActor in
                self.handle(samples)
            }
        }
        heartRateQuery?.updateHandler = { _, samples, _, _, _ in
            Task { @MainActor in
                self.handle(samples)
            }
        }
        healthStore.execute(heartRateQuery!)
    }

    func stopStreaming() {
        if let query = heartRateQuery {
            healthStore.stop(query)
            heartRateQuery = nil
        }
    }

    private func handle(_ samples: [HKSample]?) {
        guard let s = samples as? [HKQuantitySample],
            let last = s.last
        else { return }
        let bpm = last.quantity.doubleValue(for: .init(from: "count/min"))
        DispatchQueue.main.async {
            self.heartRate = bpm
        }

        // Send to iOS app via multiple methods for reliability
        sendBPMToiPhone(bpm)
    }

    // ✅ Send message to iPhone
    func sendExerciseStart(exerciseId: String) {
        let message: [String: Any] = [
            "exerciseId": exerciseId
        ]

        if WCSession.default.isReachable {
            WCSession.default.sendMessage(message, replyHandler: nil) { error in
                print("Send error:", error.localizedDescription)
            }
        }
    }

    private func sendBPMToiPhone(_ bpm: Double) {
        let message: [String: Any] = [
            "bpm": bpm, "timestamp": Date().timeIntervalSince1970,
        ]

        // Try interactive messaging first (fastest, requires reachability)
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(message, replyHandler: nil) { error in
                print(
                    "Failed to send BPM via message: \(error.localizedDescription)"
                )
            }
        }

        // Also use transferUserInfo for guaranteed delivery (works in background)
        WCSession.default.transferUserInfo(message)
    }

    // MARK: - WCSessionDelegate
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        if let error = error {
            print("WCSession activation error:", error.localizedDescription)
        } else {
            print("Watch WCSession activated")
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any])
    {
        // Receive commands from iPhone
        if message["command"] as? String == "start" {
            DispatchQueue.main.async {
                self.requestAuthorization()
                self.startStreaming()
            }
        } else if message["command"] as? String == "stop" {
            DispatchQueue.main.async {
                self.stopStreaming()
            }
        }

        // Receive progress updates from iPhone
        if let progressValue = message["progress"] as? Double,
            let isPaused = message["isPaused"] as? Bool,
            let timeRemaining = message["timeRemaining"] as? Int,
            let totalDuration = message["totalDuration"] as? Int
        {

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

    func session(
        _ session: WCSession,
        didReceiveApplicationContext applicationContext: [String: Any]
    ) {
        // Also handle application context for progress (more reliable for state sync)
        if let progressValue = applicationContext["progress"] as? Double,
            let isPaused = applicationContext["isPaused"] as? Bool,
            let timeRemaining = applicationContext["timeRemaining"] as? Int,
            let totalDuration = applicationContext["totalDuration"] as? Int
        {

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
