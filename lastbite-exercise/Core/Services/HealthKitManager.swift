//
//  HealthKitManager.swift
//  Exa
//
//  Created by Ammar Alifian Fahdan on 21/10/25.
//

import Combine
import Foundation
import HealthKit

//@MainActor
final class HealthKitManager: ObservableObject {
    private let healthStore = HKHealthStore()
    @Published var bpmThreshold: Int = -1
    
    // Workout session for background tracking
    private var workoutSession: HKWorkoutSession?
    private var workoutBuilder: HKLiveWorkoutBuilder?

    static let shared = HealthKitManager()

    init() {
        print(
            "HealthKitManager initialized, BPM Threshold: \(String(describing: bpmThreshold))"
        )
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

                        print("DoB = \(birthDate)")

                        Task { @MainActor in
                            self.bpmThreshold = self.getBPMThreshold(age)
                            print(
                                "Threshold: \(String(describing: self.bpmThreshold))"
                            )
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
        let idealBPM: Double = Double(220 - age) * 0.54
        return Int(floor(idealBPM))
    }
    
    // MARK: - Workout Session Management
    
    /// Starts a workout session to enable background tracking
    func startWorkoutSession() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("[HealthKit] Health data not available")
            return
        }
        
        // If there's already an active session, don't create a new one
        if workoutSession != nil {
            print("[HealthKit] Workout session already active")
            return
        }
        
        // Create workout configuration
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .other  // You can change this based on exercise type
        configuration.locationType = .indoor  // Change based on your needs
        
        do {
            // Create workout session
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            workoutBuilder = workoutSession?.associatedWorkoutBuilder()
            
            // Set data source
            workoutBuilder?.dataSource = HKLiveWorkoutDataSource(
                healthStore: healthStore,
                workoutConfiguration: configuration
            )
            
            // Start the session
            workoutSession?.startActivity(with: Date())
            workoutBuilder?.beginCollection(withStart: Date()) { success, error in
                if success {
                    print("[HealthKit] Workout session started successfully - background tracking enabled")
                } else {
                    print("[HealthKit] Failed to start workout collection: \(error?.localizedDescription ?? "unknown")")
                }
            }
            
        } catch {
            print("[HealthKit] Failed to start workout session: \(error.localizedDescription)")
        }
    }
    
    /// Ends the workout session
    func endWorkoutSession() {
        guard let session = workoutSession else {
            print("[HealthKit] No active workout session to end")
            return
        }
        
        print("[HealthKit] Ending workout session")
        
        // End the workout session
        session.end()
        
        // Finish the workout builder
        workoutBuilder?.endCollection(withEnd: Date()) { success, error in
            if success {
                print("[HealthKit] Workout collection ended successfully")
            } else {
                print("[HealthKit] Failed to end workout collection: \(error?.localizedDescription ?? "unknown")")
            }
        }
        
        // Clean up
        workoutSession = nil
        workoutBuilder = nil
    }
    
    /// Pauses the workout session
    func pauseWorkoutSession() {
        guard let session = workoutSession else {
            print("[HealthKit] No active workout session to pause")
            return
        }
        
        print("[HealthKit] Pausing workout session")
        session.pause()
    }
    
    /// Resumes the workout session
    func resumeWorkoutSession() {
        guard let session = workoutSession else {
            print("[HealthKit] No active workout session to resume")
            return
        }
        
        print("[HealthKit] Resuming workout session")
        session.resume()
    }
    
    var isWorkoutSessionActive: Bool {
        return workoutSession != nil
    }
}
