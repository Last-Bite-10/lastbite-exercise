//
//  HealthKitManager.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

import Combine
import Foundation
import HealthKit

@Observable
final class HealthKitService: NSObject {
    private let healthStore = HKHealthStore()

    private var workoutSession: HKWorkoutSession?
    private var workoutBuilder: HKLiveWorkoutBuilder?

    var onHeartRateUpdate: ((Int) -> Void)?
    var bpmThreshold: Int = 100

    private func getBPMThreshold(_ age: Int) -> Int {
        let idealBPM: Double = Double(220 - age) * 0.54
        return Int(floor(idealBPM))
    }

    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }

        let typesToShare: Set = [
            HKObjectType.workoutType()
        ]

        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.characteristicType(forIdentifier: .dateOfBirth)!,
        ]

        healthStore.requestAuthorization(
            toShare: typesToShare,
            read: typesToRead
        ) { success, error in
            if success {
                do {
                    let dob = try self.healthStore.dateOfBirthComponents()
                    let calendar = Calendar.current
                    if let birthDate = calendar.date(from: dob) {
                        let ageComponent = calendar.dateComponents(
                            [.year],
                            from: birthDate,
                            to: Date()
                        )
                        let age = ageComponent.year ?? 20

                        print("DoB = \(birthDate)")

                        Task { @MainActor in
                            self.bpmThreshold = self.getBPMThreshold(age)
                            print("BPM threshold : \(self.bpmThreshold)")
                        }

                        print("Threshold: \(self.bpmThreshold)")
                    }
                } catch {
                    Debugging.debug("Failed to get date of birth.")
                }
            }

            if let error = error {
                Debugging.debug(
                    "HealthKit authorization error: \(error.localizedDescription)"
                )
            } else {
                Debugging.debug("HealthKit authorization success: \(success)")
            }
        }
    }

    func startWorkout(onUpdate: ((Int) -> Void)? = nil) {
        self.onHeartRateUpdate = onUpdate

        Debugging.debug("Starting workout session...")

        // Configure workout session
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .other
        configuration.locationType = .indoor

        do {
            workoutSession = try HKWorkoutSession(
                healthStore: healthStore,
                configuration: configuration
            )
            workoutBuilder = workoutSession?.associatedWorkoutBuilder()

            workoutSession?.delegate = self
            workoutBuilder?.delegate = self

            Debugging.debug("Workout session created, delegates set")

            workoutBuilder?.dataSource = HKLiveWorkoutDataSource(
                healthStore: healthStore,
                workoutConfiguration: configuration
            )

            Debugging.debug("Data source configured")

            // Start the session FIRST
            workoutSession?.startActivity(with: Date())

            Debugging.debug("Workout activity started")

            // Then begin collection
            workoutBuilder?.beginCollection(withStart: Date()) {
                success,
                error in
                if let error = error {
                    Debugging.debug(
                        "Failed to begin collection: \(error.localizedDescription)"
                    )
                } else {
                    Debugging.debug("Collection began successfully: \(success)")
                }
            }
        } catch {
            Debugging.debug(
                "Failed to start workout: \(error.localizedDescription)"
            )
        }
    }

    func pauseWorkout() {
        workoutSession?.pause()
    }

    func stopWorkout() {
        workoutSession?.end()
        workoutBuilder?.endCollection(withEnd: Date()) { success, error in
            self.workoutBuilder?.finishWorkout(completion: { workout, error in }
            )
        }

        workoutSession = nil
        workoutBuilder = nil
        onHeartRateUpdate = nil
    }
}

extension HealthKitService: HKWorkoutSessionDelegate {
    func workoutSession(
        _ workoutSession: HKWorkoutSession,
        didChangeTo toState: HKWorkoutSessionState,
        from fromState: HKWorkoutSessionState,
        date: Date
    ) {
        Debugging.debug(
            "Workout session state: \(fromState.rawValue) -> \(toState.rawValue)"
        )
    }

    func workoutSession(
        _ workoutSession: HKWorkoutSession,
        didFailWithError error: any Error
    ) {
    }
}

extension HealthKitService: HKLiveWorkoutBuilderDelegate {
    func workoutBuilder(
        _ workoutBuilder: HKLiveWorkoutBuilder,
        didCollectDataOf collectedTypes: Set<HKSampleType>
    ) {
        guard
            let heartRateType = HKObjectType.quantityType(
                forIdentifier: .heartRate
            ),
            collectedTypes.contains(heartRateType),
            let stats = workoutBuilder.statistics(for: heartRateType),
            let quantity = stats.mostRecentQuantity()
        else { return }

        let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
        let heartRate = quantity.doubleValue(for: heartRateUnit)

        DispatchQueue.main.async { [weak self] in
            self?.onHeartRateUpdate?(Int(heartRate))
        }
    }

    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
    }
}
