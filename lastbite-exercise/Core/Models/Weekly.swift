//
//  Weekly.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 30/10/25.
//

import Foundation
import SwiftData

@Model
final class Weekly {
    var id: UUID
    var weekNumber: Int
    var startDate: Date
    var endDate: Date?
    var isCompleted: Bool

    @Relationship(deleteRule: .cascade, inverse: \ExerciseRecord.week)
    var records: [ExerciseRecord]

    init(weekNumber: Int, startDate: Date, endDate: Date? = nil) {
        self.id = UUID()
        self.weekNumber = weekNumber
        self.startDate = startDate
        self.endDate = endDate
        self.isCompleted = false
        self.records = []
    }
}
