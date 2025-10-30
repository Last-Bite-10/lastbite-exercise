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
    var equipmentAvailable: String
    var location: String
    var weather: String
    var needsTutorial: String
    var wasGood: Bool
    var timestamp: Date

    init(
        exerciseId: Int,
        exerciseName: String,
        equipmentAvailable: String,
        location: String,
        weather: String,
        needsTutorial: String,
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
