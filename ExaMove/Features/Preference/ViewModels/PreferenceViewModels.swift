//
//  PreferenceViewModels.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

import SwiftData
import SwiftUI

@Observable
final class PreferenceViewModel {
    var selectedFrequency: FrequencyType?
    var selectedEquipment: Set<EquipmentType> = []
    var selectedLocation: LocationType?

    var onDoneAction: (() -> Void)?
    var onCancelAction: (() -> Void)?

    private var modelContext: ModelContext?
    private var preference: Preference?

    private func getPreference() {
        guard let context = modelContext else { return }

        let descriptor = FetchDescriptor<Preference>()
        let preferences = (try? context.fetch(descriptor)) ?? []

        preference = preferences.first
    }

    func setup(modelContext: ModelContext, onDoneAction: @escaping () -> Void) {
        self.modelContext = modelContext

        self.onDoneAction = onDoneAction

        self.onCancelAction = {
            self.selectedFrequency = nil
            self.selectedEquipment = []
            self.selectedLocation = nil

            onDoneAction()
        }

        getPreference()
    }

    func savePreference() {
        guard let context = modelContext else { return }

        preference?.frequency = selectedFrequency
        preference?.equipmentAvailable = Array(selectedEquipment)
        preference?.location = selectedLocation
        preference?.finishQuestionnaire = true

        try? context.save()

        onDoneAction?()
    }
}
