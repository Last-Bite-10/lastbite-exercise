//
//  HealthKitManager.swift
//  Exa
//
//  Created by Ammar Alifian Fahdan on 21/10/25.
//

import Combine
import Foundation
import HealthKit

@MainActor
class HealthKitManager: ObservableObject {
    private let healthStore = HKHealthStore()
    @Published var latestBPM: Double?
    @Published var isReceivingFromWatch: Bool = false
    var bpmThreshold: Int?
    private var heartRateQuery: HKAnchoredObjectQuery?

    let notification = PassthroughSubject<[String: Any], Never>()

    static let shared = HealthKitManager()

    // Publisher for BPM updates from Watch
    var bpmPublisher: AnyPublisher<Double, Never> {
        $latestBPM
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

        WCSession.default.sendMessage(["command": "start"], replyHandler: nil) {
            error in
            print(
                "Failed to start watch monitoring: \(error.localizedDescription)"
            )
        }
        isReceivingFromWatch = true
    }

    func stopWatchHeartRateMonitoring() {
        guard WCSession.default.isReachable else { return }

        WCSession.default.sendMessage(["command": "stop"], replyHandler: nil) {
            error in
            print(
                "Failed to stop watch monitoring: \(error.localizedDescription)"
            )
        }
        isReceivingFromWatch = false
    }
    
    // MARK: - HealthKit Authorization
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable(),
            let heartRateType = HKObjectType.quantityType(
                forIdentifier: .heartRate
            ),
            let dobType = HKObjectType.characteristicType(
                forIdentifier: .dateOfBirth
            )
        else { return }

        healthStore.requestAuthorization(
            toShare: [],
            read: [heartRateType, dobType]
        ) { success, error in
            if success {
                // Populate user's DoB
                do {
                    let dob = try self.healthStore.dateOfBirthComponents()
                    let calendar = Calendar.current
                    if let birthDate = calendar.date(from: dob) {
                        let ageComponent = calendar.dateComponents(
                            [.year],
                            from: birthDate,
                            to: Date()
                        )
                        let age = ageComponent.year ?? 0

                        Task { @MainActor in
                            self.bpmThreshold = self.getBPMThreshold(age)
                        }
                    }
                } catch {
                    print(
                        "Error on extracting user's age. Setting DoB to default"
                    )
                    Task { @MainActor in
                        self.bpmThreshold = 100
                    }
                }
            } else {
                print(
                    "HealthKit auth error: \(error?.localizedDescription ?? "unknown")"
                )
            }
        }
    }

    func getBPMThreshold(_ age: Int) -> Int {
        let idealBPM: Double = Double(220 - age) * Double(64 / 100)
        return Int(floor(idealBPM))
    }

    func fetchLatestHeartRate() {
        guard
            let heartRateType = HKObjectType.quantityType(
                forIdentifier: .heartRate
            )
        else { return }

        let sort = NSSortDescriptor(
            key: HKSampleSortIdentifierStartDate,
            ascending: false
        )
        let query = HKSampleQuery(
            sampleType: heartRateType,
            predicate: nil,
            limit: 1,
            sortDescriptors: [sort]
        ) { _, samples, _ in
            guard let sample = samples?.first as? HKQuantitySample else {
                return
            }

            Task { @MainActor in
                self.latestBPM = sample.quantity.doubleValue(
                    for: HKUnit(from: "count/min")
                )
            }
        }

        healthStore.execute(query)
    }

    func startRealTimeHeartRateMonitoring() {
        guard
            let heartRateType = HKObjectType.quantityType(
                forIdentifier: .heartRate
            )
        else { return }

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
                let latestSample = samples.last as? HKQuantitySample
            else { return }

            Task { @MainActor in
                self.latestBPM = latestSample.quantity.doubleValue(
                    for: HKUnit(from: "count/min")
                )
            }
        }

        // Set update handler for real-time updates
        heartRateQuery?.updateHandler = { [weak self] _, samples, _, _, _ in
            guard let self = self,
                let samples = samples,
                let latestSample = samples.last as? HKQuantitySample
            else { return }

            Task { @MainActor in
                self.latestBPM = latestSample.quantity.doubleValue(
                    for: HKUnit(from: "count/min")
                )
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
    nonisolated func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
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

    nonisolated func session(
        _ session: WCSession,
        didReceiveMessage message: [String: Any]
    ) {
        if let bpm = message["bpm"] as? Double {
            print("BPM received : \(bpm)")
            Task { @MainActor in
                self.latestBPM = bpm
            }
        }
        if let exerciseId = message["exerciseId"] as? String {
            DispatchQueue.main.async {
                self.notification.send(message)
            }
        }
    }
}
