//
//  ConnectivityManager.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

import Foundation
import WatchConnectivity

@Observable
final class WCService: NSObject {
    var onRecordTimerUpdate: ((TimerStatus) -> Void)?
    var onHeartRateUpdate: ((Int) -> Void)?

    var isReceivingFromWatch: Bool = false

    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    // Use sendMessage for time-critical data (timer controls, heart rate)
    // This is synchronous and requires both devices to be reachable
    func sendRecordTimerStatus(
        _ status: TimerStatus
    ) {
        guard WCSession.default.isReachable else {
            Debugging.debug("⚠️ Watch not reachable for timer pause")
            return
        }

        let message: [String: Any] = [
            "type": "timerStatus",
            "status": status.rawValue,
        ]

        WCSession.default.sendMessage(message, replyHandler: nil) { error in
            Debugging.debug(
                "❌ Failed to send timer pause: \(error.localizedDescription)"
            )
        }
    }

    func sendSelectedRecord(_ record: ExerciseRecord) {
        guard WCSession.default.isReachable else { return }

        let message: [String: Any] = [
            "type": "selectedRecord",
            "recordId": record.id.uuidString,
        ]

        WCSession.default.sendMessage(message, replyHandler: nil)
    }

    // Use sendMessage for heart rate (real-time, critical)
    func sendHeartRate(_ heartRate: Int) {
        guard WCSession.default.isReachable else { return }

        let message: [String: Any] = [
            "type": "heartRate",
            "heartRate": heartRate,
        ]

        // sendMessage is faster but requires reachability
        WCSession.default.sendMessage(message, replyHandler: nil)
    }
}

extension WCService: WCSessionDelegate {
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        if let error = error {
            Debugging.debug(
                "WCSession activation failed: \(error.localizedDescription)"
            )
        } else {
            isReceivingFromWatch = true
            Debugging.debug(
                "✅ WCSession activated: \(activationState.rawValue)"
            )
        }
    }

    #if os(iOS)
        func sessionDidBecomeInactive(_ session: WCSession) {}
        func sessionDidDeactivate(_ session: WCSession) {
            session.activate()
        }
    #endif  // os(iOS)

    // Handle real-time messages (timer controls, heart rate)
    func session(_ session: WCSession, didReceiveMessage message: [String: Any])
    {
        DispatchQueue.main.async { [weak self] in
            guard let type = message["type"] as? String else { return }

            switch type {
            case "timerStatus":
                if let status = message["status"] as? TimerStatus {
                    self?.onRecordTimerUpdate?(status)
                }

            case "selectedRecord":
                if let recordIdString = message["recordID"] as? String {

                }

            case "heartRate":
                if let heartRate = message["heartRate"] as? Int {
                    self?.onHeartRateUpdate?(heartRate)
                }

            default:
                break
            }
        }
    }
}
