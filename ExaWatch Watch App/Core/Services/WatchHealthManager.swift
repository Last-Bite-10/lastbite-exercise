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
            "type": PayloadType.bpmChange.rawValue,
            "data": [
                "bpm": bpm,
                "timestamp": Date().timeIntervalSince1970
            ]
        ]

        // Use transferUserInfo for guaranteed delivery (works in background)
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

    // ✅ This is the OLD method without replyHandler - REMOVE IT
    // func session(_ session: WCSession, didReceiveMessage message: [String: Any]) { ... }

    // ✅ NEW: Implement the method WITH replyHandler to send acknowledgments back
    nonisolated func session(
        _ session: WCSession,
        didReceiveMessage message: [String: Any],
        replyHandler: @escaping ([String: Any]) -> Void
    ) {
        print("[Watch] ========================================")
        print("[Watch] didReceiveMessage (with reply) called!")
        print("[Watch] Message: \(message)")
        print("[Watch] ========================================")

        // Always send a reply to acknowledge receipt
        let reply: [String: Any] = ["status": "received"]

        // Handle commands from iPhone
        if let command = message["command"] as? String {
            Task { @MainActor in
                switch command {
                case "start":
                    self.requestAuthorization()
                    self.startStreaming()
                    print("[Watch] Started heart rate monitoring")
                case "stop":
                    self.stopStreaming()
                    print("[Watch] Stopped heart rate monitoring")
                default:
                    print("[Watch] Unknown command: \(command)")
                }
            }
            replyHandler(reply)
            return
        }

        // Receive progress updates from iPhone
        if let progressValue = message["progress"] as? Double,
            let timerStatus = message["timerStatus"] as? String,
            let timeRemaining = message["timeRemaining"] as? Int,
            let totalDuration = message["totalDuration"] as? Int,
            let timerStatusType = TimerStatusType(rawValue: timerStatus)
        {
            Task { @MainActor in
                self.receivedProgress = ProgressData(
                    progress: CGFloat(progressValue),
                    timerStatus: timerStatusType,
                    timeRemaining: timeRemaining,
                    totalDuration: totalDuration
                )
            }
            replyHandler(reply)
            return
        }

        // If we get here, send reply anyway
        replyHandler(reply)
    }

    func session(
        _ session: WCSession,
        didReceiveApplicationContext applicationContext: [String: Any]
    ) {
        print("[Watch] ========================================")
        print("[Watch] didReceiveApplicationContext called!")
        print("[Watch] Context: \(applicationContext)")
        print("[Watch] ========================================")

        // Handle progress updates from application context
        if let type = applicationContext["type"] as? String,
            let msgType = PayloadType(rawValue: type),
            msgType == .timerChange,
            let data = applicationContext["data"] as? [String: Any],
            let progressValue = data["progress"] as? Double,
            let timerStatus = data["timerStatus"] as? String,
            let timeRemaining = data["timeRemaining"] as? Int,
            let totalDuration = data["totalDuration"] as? Int,
            let timerStatusType = TimerStatusType(rawValue: timerStatus)
        {
            Task { @MainActor in
                self.receivedProgress = ProgressData(
                    progress: CGFloat(progressValue),
                    timerStatus: timerStatusType,
                    timeRemaining: timeRemaining,
                    totalDuration: totalDuration
                )
            }
        }
    }

    nonisolated func session(
        _ session: WCSession,
        didReceiveUserInfo userInfo: [String: Any] = [:]
    ) {
        print("[Watch] ========================================")
        print("[Watch] didReceiveUserInfo called!")
        print("[Watch] UserInfo: \(userInfo)")
        print("[Watch] ========================================")

        // Handle the nested structure for userInfo
        if let type = userInfo["type"] as? String,
            let msgType = PayloadType(rawValue: type)
        {
            switch msgType {
            case .bpmChange:
                // BPM updates shouldn't come to Watch, but handle just in case
                break
            case .timerChange:
                if let data = userInfo["data"] as? [String: Any],
                    let progressValue = data["progress"] as? Double,
                    let timerStatus = data["timerStatus"] as? String,
                    let timeRemaining = data["timeRemaining"] as? Int,
                    let totalDuration = data["totalDuration"] as? Int,
                    let timerStatusType = TimerStatusType(rawValue: timerStatus)
                {
                    Task { @MainActor in
                        self.receivedProgress = ProgressData(
                            progress: CGFloat(progressValue),
                            timerStatus: timerStatusType,
                            timeRemaining: timeRemaining,
                            totalDuration: totalDuration
                        )
                    }
                }
            }
        }
    }
}
