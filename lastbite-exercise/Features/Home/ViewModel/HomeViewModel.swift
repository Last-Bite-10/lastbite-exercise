//
//  HomeViewModel.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 21/11/25.
//

import SwiftUI

@Observable
final class HomeViewModel {
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
