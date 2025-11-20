//
//  WatchConnectivityManager.swift
//  Exa
//
//  Created by Ammar Alifian Fahdan on 21/10/25.
//

import Combine
import Foundation
import WatchConnectivity

// MARK: - Data Transfer Protocol
// - timerStatus CAN be emitted from either Watch and iOS
// - progress, timeRemaining, totalDuration MUST be emitted from iOS
// - Watch MUST ONLY emit timerStopped, timerStarted OR timerPaused status
// - In conflict, the latest timerStatus MUST be considered as the truth

class WatchConnectivityManager: NSObject, ObservableObject, WCSessionDelegate {
    @Published var latestBPM: Double?
    @Published var latestWatchTimerState: TimerStatusType?
    @Published var isReceivingFromWatch: Bool = false

    // Publisher for BPM updates from Watch
    var bpmPublisher: AnyPublisher<Double, Never> {
        $latestBPM
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    var watchTimerStatusPublisher: AnyPublisher<TimerStatusType, Never> {
        $latestWatchTimerState
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    override init() {
        super.init()
        setupWatchConnectivity()
    }

    // MARK: - Watch Connectivity Setup
    private func setupWatchConnectivity() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            print("[iPhone] WCSession setup - supported: true")
        } else {
            print("[iPhone] WCSession NOT supported")
        }
    }

    // MARK: - Watch Control
    func startWatchHeartRateMonitoring() {
        let session = WCSession.default
        print(
            "[iPhone] Session state - activated: \(session.activationState.rawValue), paired: \(session.isPaired), installed: \(session.isWatchAppInstalled), reachable: \(session.isReachable)"
        )

        guard session.isReachable else {
            print("[iPhone] Watch is not reachable")
            return
        }

        session.sendMessage(
            ["command": "start"],
            replyHandler: { reply in
                print("[iPhone] Received reply from watch: \(reply)")
            }
        ) { error in
            print(
                "[iPhone] Failed to start watch monitoring: \(error.localizedDescription)"
            )
        }
        isReceivingFromWatch = true
    }

    func stopWatchHeartRateMonitoring() {
        guard WCSession.default.isReachable else { return }

        WCSession.default.sendMessage(["command": "stop"], replyHandler: nil) {
            error in
            print(
                "[iPhone] Failed to stop watch monitoring: \(error.localizedDescription)"
            )
        }
        isReceivingFromWatch = false
    }

    // MARK: - WCSessionDelegate
    nonisolated func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        print("[iPhone] ========================================")
        print("[iPhone] WCSession activation completed")
        print("[iPhone] State: \(activationState.rawValue)")
        print("[iPhone] Paired: \(session.isPaired)")
        print("[iPhone] Watch app installed: \(session.isWatchAppInstalled)")
        print("[iPhone] Reachable: \(session.isReachable)")
        if let error = error {
            print("[iPhone] Error: \(error.localizedDescription)")
        }
        print("[iPhone] ========================================")
    }

    nonisolated func sessionDidBecomeInactive(_ session: WCSession) {
        print("[iPhone] WCSession became inactive")
    }

    nonisolated func sessionDidDeactivate(_ session: WCSession) {
        print("[iPhone] WCSession deactivated")
        session.activate()
    }

    nonisolated func session(
        _ session: WCSession,
        didReceiveMessage message: [String: Any]
    ) {
        print("[iPhone] ========================================")
        print("[iPhone] didReceiveMessage called!")
        print("[iPhone] Message: \(message)")
        print("[iPhone] ========================================")

        if let type = message["type"] as? String,
            let msgType = PayloadType(rawValue: type)
        {
            switch msgType {
            case .bpmChange:
                // The BPM is nested inside the "data" dictionary
                if let data = message["data"] as? [String: Any],
                    let bpm = data["bpm"] as? Double
                {
                    print("[iPhone] BPM extracted: \(bpm)")
                    Task { @MainActor in
                        self.latestBPM = bpm
                        print("[iPhone] latestBPM updated to: \(bpm)")
                    }
                } else {
                    print("[iPhone] Failed to extract BPM from data")
                }
            case .timerChange:
                // Handle timer changes if needed
                if let data = message["data"] as? [String: Any] {
                    print("[iPhone] Timer change data: \(data)")
                    
                }
            default:
                // Rest of messages is ack, for now just ignore
                print("[iPhone] ACK message")
            }
        }
    }

    nonisolated func session(
        _ session: WCSession,
        didReceiveUserInfo userInfo: [String: Any] = [:]
    ) {
        print("[iPhone] ========================================")
        print("[iPhone] didReceiveUserInfo called!")
        print("[iPhone] UserInfo: \(userInfo)")
        print("[iPhone] ========================================")

        // Handle the same nested structure for userInfo
        if let type = userInfo["type"] as? String,
            let msgType = PayloadType(rawValue: type)
        {
            switch msgType {
            case .bpmChange:
                if let data = userInfo["data"] as? [String: Any],
                    let bpm = data["bpm"] as? Double
                {
                    print("[iPhone] BPM from userInfo: \(bpm)")
                    Task { @MainActor in
                        self.latestBPM = bpm
                        print("[iPhone] latestBPM updated to: \(bpm)")
                    }
                }
            case .timerChange:
                if let data = userInfo["data"] as? [String: Any] {
                    print("[iPhone] Timer change data from userInfo: \(data)")
                    
                    if let retrievedTimerStatusString = data["timerStatus"] as? String,
                       let retrievedTimerStatus = TimerStatusType(rawValue: retrievedTimerStatusString) {
                        Task { @MainActor in
                            self.latestWatchTimerState = retrievedTimerStatus
                            print("[iPhone] Valid state, timerStatus updated to: \(retrievedTimerStatus)")
                        }
                    }
                    
                    // Only take timerStatus
                }
                
            default:
                print("[iPhone] ACK message")
            }
        }
    }

    nonisolated func sessionReachabilityDidChange(_ session: WCSession) {
        print("[iPhone] ========================================")
        print("[iPhone] Reachability changed: \(session.isReachable)")
        print("[iPhone] ========================================")
    }
}
