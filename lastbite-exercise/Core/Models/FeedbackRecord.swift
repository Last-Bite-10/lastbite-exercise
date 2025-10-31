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
    var exerciseId: Int
    var exerciseName: String
    var equipmentAvailable: EquipmentType // DIUBAH dari String
    var location: LocationType           // DIUBAH dari String
    var weather: String
    var needsTutorial: Bool              // DIUBAH dari String
    var wasGood: Bool
    var timestamp: Date

    init(
        exerciseId: Int,
        exerciseName: String,
        equipmentAvailable: EquipmentType, // DIUBAH
        location: LocationType,           // DIUBAH
        weather: String,
        needsTutorial: Bool,              // DIUBAH
        wasGood: Bool
    ) {
        self.id = UUID()
        self.exerciseId = exerciseId
        self.exerciseName = exerciseName
        self.equipmentAvailable = equipmentAvailable
        self.location = location
        self.weather = weather
        self.needsTutorial = needsTutorial
        self.wasGood = wasGood
        self.timestamp = Date()
    }
}
