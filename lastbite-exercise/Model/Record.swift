//
//  Record.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 24/10/25.
//

import Foundation
import SwiftData

@Model
class Record {
    var id: UUID
    var date: Date
    var weekNumber: Int
    var activetime: TimeInterval?
    var totalTime: TimeInterval?
    var targetTime: TimeInterval
    var exercise: Exercise

    init(
        date: Date,
        weekNumber: Int,
        chosenFrequency: FrequencyType,
        exercise: Exercise
    ) {
        self.id = UUID()
        self.date = date
        self.weekNumber = weekNumber
        self.targetTime = Record.getDistributedTargetTime(
            chosenFrequency: chosenFrequency,
            weekNumber: weekNumber
        )
        self.exercise = exercise
    }

    static private func getDistributedTargetTime(
        chosenFrequency: FrequencyType,
        weekNumber: Int
    )
        -> TimeInterval
    {
        switch chosenFrequency {
        case .oneDay:
            return getBaseTargetTime(weekNumber: weekNumber) / 1
        case .twoDays:
            return getBaseTargetTime(weekNumber: weekNumber) / 2
        case .threeDays:
            return getBaseTargetTime(weekNumber: weekNumber) / 3
        case .fourDays:
            return getBaseTargetTime(weekNumber: weekNumber) / 4
        case .fiveDays:
            return getBaseTargetTime(weekNumber: weekNumber) / 5
        }
    }

    static private func getBaseTargetTime(weekNumber: Int) -> TimeInterval {
        switch weekNumber {
        case 1:
            return 30
        case 2:
            return 36
        case 3:
            return 45
        case 4:
            return 60
        case 5:
            return 100
        case 6:
            return 120
        default:
            return 150
        }
    }
}
