//
//  RecommendationViewModel.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

import SwiftUI

@Observable class RecommendationViewModel {
    var selectedFrequency: FrequencyType = .oneDay
    var selectedTools: Set<ToolType> = []
    var selectedLocation: LocationType = .indoor
}
