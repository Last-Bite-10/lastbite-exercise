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
final class HealthKitService: NSObject, HKWorkoutSessionDelegate,
    HKLiveWorkoutBuilderDelegate
{
    static let shared = HealthKitService()

    private let healthStore = HKHealthStore()

    private var workoutSession: HKWorkoutSession?
    private var workoutBuilder: HKLiveWorkoutBuilder?

    var onHeartRateUpdate: ((Int) -> Void)?
    var bpmThreshold: Int = -1

    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }

        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.characteristicType(forIdentifier: .dateOfBirth)!,
        ]

        healthStore.requestAuthorization(toShare: [], read: typesToRead) {
            success,
            error in
            if let error = error {
                Debugging.debug(
                    "HealthKit authorization error: \(error.localizedDescription)"
                )
            }
        }
    }

    func startWorkout(onUpdate: @escaping (Int) -> Void) {
        self.onHeartRateUpdate = onUpdate

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

            workoutBuilder?.dataSource = HKLiveWorkoutDataSource(
                healthStore: healthStore,
                workoutConfiguration: configuration
            )

            workoutSession?.startActivity(with: Date())
            workoutBuilder?.beginCollection(
                withStart: Date(),
                completion: { success, error in }
            )
        } catch {
            Debugging.debug(
                "Failed to start workout: \(error.localizedDescription)"
            )
        }
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

    // MARK: - Live updates
    func workoutBuilder(
        _ workoutBuilder: HKLiveWorkoutBuilder,
        didCollectDataOf types: Set<HKSampleType>
    ) {
        guard
            let heartRateType = HKObjectType.quantityType(
                forIdentifier: .heartRate
            ),
            types.contains(heartRateType),
            let stats = workoutBuilder.statistics(for: heartRateType),
            let quantity = stats.mostRecentQuantity()
        else { return }

        let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
        let heartRate = quantity.doubleValue(for: heartRateUnit)

        DispatchQueue.main.async { [weak self] in
            self?.onHeartRateUpdate?(Int(heartRate))
        }
    }

    // MARK: - Required delegate stubs
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
    }

    func workoutSession(
        _ workoutSession: HKWorkoutSession,
        didFailWithError error: Error
    ) {
        Debugging.debug("Workout session error: \(error.localizedDescription)")
    }

    func workoutSession(
        _ workoutSession: HKWorkoutSession,
        didChangeTo toState: HKWorkoutSessionState,
        from fromState: HKWorkoutSessionState,
        date: Date
    ) {}
}
