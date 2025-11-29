//
//  ExeriseViewModel.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

import SwiftUI

@Observable
final class ExerciseViewModel {
    var showQuestionnaire: Bool = false
    var showPlan: Bool = false
    var showPlanModifySheet = false
    var showTutorial: Bool = false

    var currentlyViewedPlan: [ExerciseRecord] = []
    var currentlyViewedDate: Date = Date()

    func onDoneAction() {
        showQuestionnaire = false
        showPlan = true
        showTutorial = true
    }

    func onCancelAction(preference: Preference) {
        showQuestionnaire = false
        preference.planChosen = nil
    }
}
