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
    var id: UUID
    var isUsingPlan: Bool
    var frequency: FrequencyType?
    var equipmentAvailable: [EquipmentType]
    var location: LocationType?
    var lastUpdated: Date

    init(
        isUsingPlan: Bool = false,
        frequency: FrequencyType? = nil,
        equipmentAvailable: [EquipmentType] = [],
        location: LocationType? = nil
    ) {
        self.id = UUID()
        self.isUsingPlan = isUsingPlan
        self.frequency = frequency
        self.equipmentAvailable = equipmentAvailable
        self.location = location
        self.lastUpdated = Date()
    }
}
