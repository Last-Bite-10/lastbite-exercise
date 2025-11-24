//
//  FeedbackRecord.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 30/10/25.
//

import Foundation
import SwiftData

@Model
final class FeedbackRecord {
    var id: UUID
    var exercise: Exercise?
    var equipments: [EquipmentType]
    var location: LocationType
    var weather: WeatherType
    var needsTutorial: Bool
    var isCompleted: Bool
    var timestamp: Date

    init(
        exercise: Exercise,
        equipments: [EquipmentType],
        location: LocationType,
        weather: WeatherType,
        needsTutorial: Bool,
        isCompleted: Bool
    ) {
        self.id = UUID()
        self.exercise = exercise
        self.equipments = equipments
        self.location = location
        self.weather = weather
        self.needsTutorial = needsTutorial
        self.isCompleted = isCompleted
        self.timestamp = Date()
    }
}
