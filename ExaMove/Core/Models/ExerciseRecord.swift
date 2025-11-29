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
    var isRecording: Bool = false
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
        self.id = UUID()
        self.exercise = exercise
        self.requiredSeconds = requiredSeconds
        self.recordedSeconds = 0
        self.isCompleted = false
        self.usedAt = usedAt
        self.createdAt = Date()
        self.week = week
    }
}

extension TimeInterval {
    func getMinutes() -> Int {
        return Int(self) / 60
    }
}
