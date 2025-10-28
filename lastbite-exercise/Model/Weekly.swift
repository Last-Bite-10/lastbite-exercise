//
//  Weekly.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 24/10/25.
//

import Foundation
import SwiftData

@Model
class Weekly {
    var id: UUID
    var weekNumber: Int
    var startDate: Date
    var endDate: Date?

    init(
        weekNumber: Int,
        startDate: Date,
    ) {
        self.id = UUID()
        self.weekNumber = weekNumber
        self.startDate = startDate
    }
}
