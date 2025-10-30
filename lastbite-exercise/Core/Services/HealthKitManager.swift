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
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    // MARK: - Watch Control
    func startWatchHeartRateMonitoring() {
        guard WCSession.default.isReachable else {
            print("Watch is not reachable")
            return
        }
        
        WCSession.default.sendMessage(["command": "start"], replyHandler: nil) { error in
            print("Failed to start watch monitoring: \(error.localizedDescription)")
        }
        isReceivingFromWatch = true
    }
    
    func stopWatchHeartRateMonitoring() {
        guard WCSession.default.isReachable else { return }
        
        WCSession.default.sendMessage(["command": "stop"], replyHandler: nil) { error in
            print("Failed to stop watch monitoring: \(error.localizedDescription)")
        }
        isReceivingFromWatch = false
    }

    // MARK: - HealthKit Authorization
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable(),
              let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }

        healthStore.requestAuthorization(toShare: [], read: [heartRateType]) { success, error in
            if success {
                self.fetchLatestHeartRate()
            } else {
                print("HealthKit auth error: \(error?.localizedDescription ?? "unknown")")
            }
        }
    }

    func fetchLatestHeartRate() {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }

        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(
            sampleType: heartRateType,
            predicate: nil,
            limit: 1,
            sortDescriptors: [sort]
        ) { _, samples, _ in
            guard let sample = samples?.first as? HKQuantitySample else { return }

            Task { @MainActor in
                self.latestBPM = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            }
        }

        healthStore.execute(query)
    }

    func startRealTimeHeartRateMonitoring() {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }

        // Stop any existing query
        if let existingQuery = heartRateQuery {
            healthStore.stop(existingQuery)
        }

        // Create anchored query for real-time updates
        heartRateQuery = HKAnchoredObjectQuery(
            type: heartRateType,
            predicate: nil,
            anchor: nil,
            limit: HKObjectQueryNoLimit
        ) { [weak self] _, samples, _, _, _ in
            guard let self = self,
                  let samples = samples,
                  let latestSample = samples.last as? HKQuantitySample else { return }

            Task { @MainActor in
                self.latestBPM = latestSample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            }
        }

        // Set update handler for real-time updates
        heartRateQuery?.updateHandler = { [weak self] _, samples, _, _, _ in
            guard let self = self,
                  let samples = samples,
                  let latestSample = samples.last as? HKQuantitySample else { return }

            Task { @MainActor in
                self.latestBPM = latestSample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            }
        }

        if let query = heartRateQuery {
            healthStore.execute(query)
        }
    }

    func stopRealTimeHeartRateMonitoring() {
        if let query = heartRateQuery {
            healthStore.stop(query)
            heartRateQuery = nil
        }
    }
    
    // MARK: - WCSessionDelegate
    nonisolated func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation error:", error.localizedDescription)
        } else {
            print("WCSession activated with state: \(activationState.rawValue)")
        }
    }
    
    nonisolated func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession became inactive")
    }
    
    nonisolated func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession deactivated")
        session.activate()
    }
    
    nonisolated func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        if let bpm = message["bpm"] as? Double {
            Task { @MainActor in
                self.latestBPM = bpm
            }
        }
    }
}
