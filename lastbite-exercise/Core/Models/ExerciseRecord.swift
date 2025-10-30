//
//  ExerciseRecord.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 30/10/25.
//

import Foundation
import SwiftData

@Model
final class ExerciseRecord {
    var id: UUID
    var exerciseName: String
    var exerciseId: Int
    var requiredMinutes: Int
    var recordedMinutes: Int
    var isCompleted: Bool
    var createdAt: Date
    var completedAt: Date?

    var week: Weekly?

    init(
        exerciseName: String,
        exerciseId: Int,
        requiredMinutes: Int,
        week: Weekly? = nil
    ) {
        self.id = UUID()
        self.exerciseName = exerciseName
        self.exerciseId = exerciseId
        self.requiredMinutes = requiredMinutes
        self.recordedMinutes = 0
        self.isCompleted = false
        self.createdAt = Date()
        self.week = week
    }
}
