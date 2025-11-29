//
//  ExerciseRecord.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 30/10/25.
//

import Foundation
import SwiftData

@Model
final class ExerciseRecord: Identifiable {
    var id: UUID = UUID()
    var exercise: Exercise?
    var requiredSeconds: TimeInterval = 0
    var recordedSeconds: TimeInterval = 0
    var isCompleted: Bool = false
    var usedAt: Date = Date()
    var createdAt: Date = Date()
    var completedAt: Date?
    var week: Weekly?

    init(
        exercise: Exercise,
        requiredSeconds: TimeInterval,
        usedAt: Date,
        week: Weekly? = nil
    ) {
        self.exercise = exercise
        self.requiredSeconds = requiredSeconds
        self.usedAt = usedAt
        self.week = week
    }
}

extension TimeInterval {
    func getMinutes() -> Int {
        return Int(self) / 60
    }
}
