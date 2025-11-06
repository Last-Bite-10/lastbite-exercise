//
//  Preference.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 30/10/25.
//

import Foundation
import SwiftData

@Model
final class Preference {
    var id: UUID = UUID()
    var planChosen: PlanType?
    var frequency: FrequencyType?
    var equipmentAvailable: [EquipmentType] = []
    var location: LocationType?
    var lastUpdated: Date = Date()

    init(
        isUsingPlan: Bool = false,
        planChosen: PlanType? = nil,
        frequency: FrequencyType? = nil,
        equipmentAvailable: [EquipmentType] = [],
        location: LocationType? = nil
    ) {
        self.id = UUID()
        self.planChosen = planChosen
        self.frequency = frequency
        self.equipmentAvailable = equipmentAvailable
        self.location = location
        self.lastUpdated = Date()
    }
}
