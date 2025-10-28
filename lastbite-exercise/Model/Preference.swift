//
//  User.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 24/10/25.
//

import Foundation
import SwiftData

@Model
final class Preference {
    var id: UUID
    var isUsingPlan: Bool
    var equipments: [EquipmentType]
    var location: LocationType
    var frequency: FrequencyType

    init(
        isUsingPlan: Bool,
        equipments: [EquipmentType],
        location: LocationType,
        frequency: FrequencyType
    ) {
        self.id = UUID()
        self.isUsingPlan = isUsingPlan
        self.equipments = equipments.isEmpty ? [.none] : equipments
        self.location = location
        self.frequency = frequency
    }
}

enum EquipmentType: String, Codable, Hashable, CaseIterable {
    case none = "None"
    case jumpRope = "Jump Rope"
    case exerciseMat = "Exercise Mat"
    case dumbbell = "Dumbbell"
    case stairs = "Stairs"
    case wallSurface = "Wall Surface"
    case racket = "Racket"
    case bicycle = "Bicycle"
    case paddleTennis = "Paddle Tennis"
    case volleyball = "Volleyball"
}

enum LocationType: String, Codable, Hashable, CaseIterable {
    case indoor = "Indoor"
    case outdoor = "Outdoor"
    case both = "Both"
}

enum FrequencyType: String, Codable, Hashable, CaseIterable {
    case oneDay = "1 Day per week"
    case twoDays = "2 Days per week"
    case threeDays = "3 Days per week"
    case fourDays = "4 Days per week"
    case fiveDays = "5 Days per week"
}
