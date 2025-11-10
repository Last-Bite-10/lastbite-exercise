//
//  WatchConnectivityManager.swift
//  ExaWatch Watch App
//
//  Created by Assistant on 08/11/25.
//

import Combine
import Foundation
import WatchConnectivity

@MainActor
class WatchConnectivityManager: NSObject, ObservableObject, WCSessionDelegate {
    @Published var isReachable: Bool = false

    override init() {
        super.init()
        setupWatchConnectivity()
    }

    // MARK: - Watch Connectivity Setup
    private func setupWatchConnectivity() {
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    // MARK: - Commands to iPhone
    func sendStartToiPhone() {
        guard WCSession.default.isReachable else { return }
        WCSession.default.sendMessage(["command": "start"], replyHandler: nil) {
            error in
            print(
                "[Watch] Failed to send start command to iPhone: \(error.localizedDescription)"
            )
        }
    }

    func sendStopToiPhone() {
        guard WCSession.default.isReachable else { return }
        WCSession.default.sendMessage(["command": "stop"], replyHandler: nil) {
            error in
            print(
                "[Watch] Failed to send stop command to iPhone: \(error.localizedDescription)"
            )
        }
    }

    // MARK: - WCSessionDelegate
    nonisolated func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        if let error = error {
            print(
                "[Watch] WCSession activation error:",
                error.localizedDescription
            )
        } else {
            print(
                "[Watch] WCSession activated with state: \(activationState.rawValue)"
            )
        }
    }

    nonisolated func sessionReachabilityDidChange(_ session: WCSession) {
        Task { @MainActor in
            self.isReachable = session.isReachable
        }
    }

    // Keep this to debug incoming messages if needed
    nonisolated func session(
        _ session: WCSession,
        didReceiveMessage message: [String: Any]
    ) {
        print("[Watch] didReceiveMessage:", message)
    }
}
