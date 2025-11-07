//
//  Health.swift
//  Exa
//
//  Created by Ammar Alifian Fahdan on 21/10/25.
//

import Foundation
import HealthKit
import WatchConnectivity
import Combine

@MainActor
class HealthKitManager: NSObject, ObservableObject, WCSessionDelegate {
    private let healthStore = HKHealthStore()
    @Published var latestBPM: Double?
    @Published var isReceivingFromWatch: Bool = false
    var bpmThreshold: Int?
    private var heartRateQuery: HKAnchoredObjectQuery?
    
    // Publisher for BPM updates from Watch
    var bpmPublisher: AnyPublisher<Double, Never> {
        $latestBPM
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    override init() {
        super.init()
        setupWatchConnectivity()
        requestAuthorization()
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
        print("[iPhone] Session state - activated: \(session.activationState.rawValue), paired: \(session.isPaired), installed: \(session.isWatchAppInstalled), reachable: \(session.isReachable)")
        
        guard session.isReachable else {
            print("[iPhone] Watch is not reachable")
            return
        }
        
        session.sendMessage(["command": "start"], replyHandler: { reply in
            print("[iPhone] Received reply from watch: \(reply)")
        }) { error in
            print("[iPhone] Failed to start watch monitoring: \(error.localizedDescription)")
        }
        isReceivingFromWatch = true
    }
    
    func stopWatchHeartRateMonitoring() {
        guard WCSession.default.isReachable else { return }
        
        WCSession.default.sendMessage(["command": "stop"], replyHandler: nil) { error in
            print("[iPhone] Failed to stop watch monitoring: \(error.localizedDescription)")
        }
        isReceivingFromWatch = false
    }

    // MARK: - HealthKit Authorization
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable(),
              let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate),
              let dobType = HKObjectType.characteristicType(forIdentifier: .dateOfBirth)
        else { return }

        healthStore.requestAuthorization(toShare: [], read: [heartRateType, dobType]) { success, error in
            if success {
                // Populate user's DoB
                do {
                    let dob = try self.healthStore.dateOfBirthComponents()
                    let calendar = Calendar.current
                    if let birthDate = calendar.date(from: dob) {
                        let ageComponent = calendar.dateComponents([.year], from: birthDate, to: Date())
                        let age = ageComponent.year ?? 0
                        
                        Task { @MainActor in
                            self.bpmThreshold = self.getBPMThreshold(age)
                        }
                    }
                } catch {
                    print("Error on extracting user's age. Setting DoB to default")
                    Task { @MainActor in
                        self.bpmThreshold = 100
                    }
                }
            } else {
                print("HealthKit auth error: \(error?.localizedDescription ?? "unknown")")
            }
        }
    }
    
    func getBPMThreshold(_ age: Int) -> Int {
        let idealBPM: Double = Double(220 - age) * Double(64 / 100)
        return Int(floor(idealBPM))
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
    
    nonisolated func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        print("[iPhone] ========================================")
        print("[iPhone] didReceiveMessage called!")
        print("[iPhone] Message: \(message)")
        print("[iPhone] ========================================")
        
        if let bpm = message["bpm"] as? Double {
            print("[iPhone] BPM extracted: \(bpm)")
            Task { @MainActor in
                self.latestBPM = bpm
                print("[iPhone] latestBPM updated to: \(bpm)")
            }
        }
    }
    
    nonisolated func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        print("[iPhone] ========================================")
        print("[iPhone] didReceiveUserInfo called!")
        print("[iPhone] UserInfo: \(userInfo)")
        print("[iPhone] ========================================")
        
        if let bpm = userInfo["bpm"] as? Double {
            print("[iPhone] BPM from userInfo: \(bpm)")
            Task { @MainActor in
                self.latestBPM = bpm
                print("[iPhone] latestBPM updated to: \(bpm)")
            }
        }
    }
    
    nonisolated func sessionReachabilityDidChange(_ session: WCSession) {
        print("[iPhone] ========================================")
        print("[iPhone] Reachability changed: \(session.isReachable)")
        print("[iPhone] ========================================")
    }
}
