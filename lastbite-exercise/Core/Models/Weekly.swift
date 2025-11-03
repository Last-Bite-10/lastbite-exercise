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
    var id: UUID = UUID()
    var weekNumber: Int = 0
    var startDate: Date = Date()
    var endDate: Date?
    var isCompleted: Bool = false

    @Relationship(deleteRule: .cascade, inverse: \ExerciseRecord.week)
    var records: [ExerciseRecord]?

    init(weekNumber: Int, startDate: Date, endDate: Date? = nil) {
        self.id = UUID()
        self.weekNumber = weekNumber
        self.startDate = startDate
        self.endDate = endDate
        self.isCompleted = false
        self.records = []
    }
}
