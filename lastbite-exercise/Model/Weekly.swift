//
//  Weekly.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 24/10/25.
//

import Foundation

struct Weekly: Codable, Hashable {
    var id: UUID
    var weekNumber: Int
    var startDate: Date
    var endDate: Date
    var frequency: FrequencyType
}

enum FrequencyType: String, Codable, Hashable, CaseIterable {
    case oneDay = "1 Day (30 Minutes per Day)"
    case twoDays = "2 Day (15 Minutes per Day)"
    case threeDays = "3 Days (10 Minutes per Day)"
    case fourDays = "4 Days (8 Minutes per Day)"
    case fiveDays = "5 Days (6 Minutes per Day)"
}
