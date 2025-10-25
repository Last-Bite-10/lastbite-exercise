//
//  RecommendationViewModel.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

import SwiftUI

@Observable class RecommendationViewModel {
    var selectedFrequency: FrequencyType = .oneDay
    var selectedTools: Set<ToolsType> = []
    var selectedLocation: LocationType = .indoor
}

enum FrequencyType: String, CaseIterable {
    case oneDay = "1 Day (30 Minutes per Day)"
    case twoDays = "2 Day (15 Minutes per Day)"
    case threeDays = "3 Days (10 Minutes per Day)"
    case fourDays = "4 Days (8 Minutes per Day)"
    case fiveDays = "5 Days (6 Minutes per Day)"
}

enum LocationType: String, CaseIterable {
    case indoor = "Indoor"
    case outdoor = "Outdoor"
    case both = "Both"
}

enum ToolsType: String, CaseIterable {
    case matress = "Matress"
    case dumbbell = "Dumbbell"
    case bike = "Bike"
    case yogaMat = "Yoga Mat"
    case jumpRope = "Jump Rope"
    case stairs = "Stairs"
}
