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

    // Callback function for synchronization
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
        _ status: TimerStatus,
        for record: ExerciseRecord
    ) {
        guard WCSession.default.isReachable else { return }

        let message: [String: Any] = [
            "type": "timerStatus",
            "status": status.rawValue,
            "recordId": record.id.uuidString,
        ]

        Debugging.debug("Send Record Timer Status Record: \(message)")

        WCSession.default.sendMessage(message, replyHandler: nil) { error in
            Debugging.debug(
                "❌ Failed to send timer pause: \(error.localizedDescription)"
            )
        }
    }

    // Use sendMessage for heart rate (real-time, critical)
    func sendHeartRate(_ heartRate: Int) {
        guard WCSession.default.isReachable else { return }

        let message: [String: Any] = [
            "type": "heartRate",
            "heartRate": heartRate,
        ]

        Debugging.debug("Send Heart Rate: \(message)")

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
        DispatchQueue.main.async {
            guard let type = message["type"] as? String else { return }

            switch type {

            case "timerStatus":
                Debugging.debug("Received timer status update")
                NotificationCenter.default.post(
                    name: .receiveRecordTimerStatusUpdate,
                    object: message
                )

            case "heartRate":
                Debugging.debug("Received heart rate update")
                NotificationCenter.default.post(
                    name: .receiveHeartRateUpdate,
                    object: message["heartRate"]
                )

            default:
                break
            }
        }
    }
}

extension Notification.Name {
    static let receiveRecordTimerStatusUpdate = Notification.Name(
        "receiveRecordTimerStatusUpdate"
    )
    static let receiveHeartRateUpdate = Notification.Name(
        "receiveHeartRateUpdate"
    )
}
