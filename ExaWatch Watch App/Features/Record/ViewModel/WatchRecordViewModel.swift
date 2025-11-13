//
//  WatchRecordViewModel.swift
//  ExaWatch Watch App
//
//  Created by Ammar Alifian Fahdan on 27/10/25.
//

import Combine
import SwiftUI
import WatchConnectivity

// MARK: - Main Actors
@MainActor
class WatchRecordViewModel: ObservableObject {
    @Published var progress: CGFloat = 1.0
    @Published var timerStatus: TimerStatusType = .timerStopped
    @Published var timeRemaining: Int = 0
    @Published var totalDuration: Int = 0

    private var cancellables = Set<AnyCancellable>()
    private var watchConnectivityManager: WatchConnectivityManager?

    var timeRemainingFormatted: String {
        return formatTime(duration: abs(timeRemaining))
    }

    var timeTotalFormatted: String {
        return formatTime(duration: totalDuration)
    }

    func connectToHealthManager(_ healthManager: WatchHealthManager) {
        // Subscribe to progress updates from iPhone
        healthManager.$receivedProgress
            .sink { [weak self] progressData in
                self?.updateProgress(progressData)
            }
            .store(in: &cancellables)
    }

    func attachWatchConnectivityManager(_ manager: WatchConnectivityManager) {
        self.watchConnectivityManager = manager
    }

    private func updateProgress(_ data: ProgressData?) {
        guard let data = data else { return }

        self.progress = data.progress
        self.timerStatus = data.timerStatus
        self.timeRemaining = data.timeRemaining
        self.totalDuration = data.totalDuration
    }
    
    func sendProgressToiPhone(data: ProgressData) {
        guard WCSession.default.activationState == .activated else {
            print("[Watch] WCSession not activated")
            return
        }
        
        let progressMessage: [String: Any] = [
            "type": PayloadType.timerChange.rawValue,
            "data": [
                "progress": Double(data.progress),
                "timerStatus": data.timerStatus.rawValue,
                "timeRemaining": data.timeRemaining,
                "totalDuration": data.totalDuration
            ]
        ]
        
        // Use application context for state sync (most reliable)
        do {
            try WCSession.default.updateApplicationContext(progressMessage)
            print("[Watch] Successfully updated application context with progress")
        } catch {
            print("[Watch] Failed to update application context: \(error.localizedDescription)")
        }
        
        // Use transferUserInfo for guaranteed delivery (works in background)
        WCSession.default.transferUserInfo(progressMessage)
        print("[Watch] Progress queued for delivery via transferUserInfo")
    }
    
    func sendCustomMessageToiPhone(message: [String: Any]) {
        guard WCSession.default.activationState == .activated else {
            print("[Watch] WCSession not activated")
            return
        }
        
        guard WCSession.default.isReachable else {
            print("[Watch] iPhone is not reachable")
            return
        }
        
        WCSession.default.sendMessage(message, replyHandler: { reply in
            print("[Watch] Received reply from iPhone: \(reply)")
        }) { error in
            print("[Watch] Failed to send custom message: \(error.localizedDescription)")
        }
    }
}

struct ProgressData {
    let progress: CGFloat
    let timerStatus: TimerStatusType
    let timeRemaining: Int
    let totalDuration: Int
}

// MARK: - Helper Functions
private func formatTime(duration: Int) -> String {
    return
        "\(String(format: "%02d", duration / 60)):\(String(format: "%02d", duration % 60))"
}
