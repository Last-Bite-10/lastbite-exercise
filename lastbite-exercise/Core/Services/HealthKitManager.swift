//
//  HealthKitManager.swift
//  Exa
//
//  Created by Ammar Alifian Fahdan on 21/10/25.
//

import Foundation
import HealthKit

@MainActor
class HealthKitManager: ObservableObject {
    private let healthStore = HKHealthStore()
    @Published var bpmThreshold: Int?
    
    init() {
        requestAuthorization()
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
}
