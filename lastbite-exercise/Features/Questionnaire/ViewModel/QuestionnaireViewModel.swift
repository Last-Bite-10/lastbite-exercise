//
//  RecommendationViewModel.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

import SwiftUI

@Observable
class QuestionnaireViewModel {
    var selectedFrequency: FrequencyType = .oneDay
    var selectedEquipment: Set<EquipmentType> = []
    var selectedLocation: LocationType = .indoor
}
