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
    var finishQuestionnaire: Bool = false
    var lastUpdated: Date = Date()

    init() {}
}
