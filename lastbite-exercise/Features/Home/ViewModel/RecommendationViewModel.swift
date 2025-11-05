//
//  CoreViewModel.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 30/10/25.
//

import SwiftData
import SwiftUI

@Observable
class RecommendationViewModel {
    var currentWeek: Weekly?

    private var modelContext: ModelContext?
    private let recommender = ExerciseRecommender.shared

    func setup(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadOrCreateCurrentWeek()
    }

    func loadOrCreateCurrentWeek() {
        guard let context = modelContext else { return }

        let descriptor = FetchDescriptor<Weekly>(sortBy: [
            SortDescriptor(\.weekNumber, order: .reverse)
        ])
        let weeklies = try? context.fetch(descriptor)

        let calendar = Calendar.current
        let today = Date()

        // Check if we have a current week
        if let latestWeek = weeklies?.first,
            calendar.isDate(
                today,
                equalTo: latestWeek.startDate,
                toGranularity: .weekOfYear
            )
        {
            currentWeek = latestWeek
        } else {
            // Create new week
            let weekNumber = (weeklies?.first?.weekNumber ?? 0) + 1
            let startOfWeek = calendar.startOfDay(for: today)

            let newWeek = Weekly(
                weekNumber: weekNumber,
                startDate: startOfWeek,
            )
            context.insert(newWeek)
            try? context.save()
            currentWeek = newWeek
        }
    }

    func initializeWeeklyExercises(preference: Preference) {
        guard let context = modelContext,
            let week = currentWeek,
            week.records!.isEmpty
        else { return }

        // Load feedback data
        let feedbackDescriptor = FetchDescriptor<FeedbackRecord>()
        let feedbackRecords = try? context.fetch(feedbackDescriptor)

        if let feedbacks = feedbackRecords {
            recommender.loadFeedback(feedbacks)
        }

        // Get recommendations
        let recommendations = recommender.recommend(
            equipments: preference.equipmentAvailable,
            location: preference.location ?? .indoor,
        )

        // Create 2 exercise records for this week
        let topExercises = recommendations.prefix(2)
        let minutes = extractMinutes(
            from: preference.frequency ?? .oneDay,
            isUsingBeginnerPlan: preference.planChosen == .beginner
        )

        for (exercise, _) in topExercises {
            let record = ExerciseRecord(
                exercise: exercise,
                requiredMinutes: minutes,
                week: week
            )
            context.insert(record)
            week.records!.append(record)

            print("Inserted exercise: \(exercise.name) with \(minutes) minutes")
        }

        try? context.save()
    }

    func modifyExerciseRecords(records: [ExerciseRecord]) {
        guard let context = modelContext else { return }
        currentWeek?.records = records
        try? context.save()
    }

    func completeExercise(record: ExerciseRecord, minutes: Int) {
        guard let context = modelContext else { return }

        // Check if all exercises in the week are completed
        if let week = currentWeek {
            let allCompleted = week.records!.allSatisfy { $0.isCompleted }
            week.isCompleted = allCompleted
            week.endDate = allCompleted ? Date() : nil
        }

        try? context.save()
    }

    private func beginnerPlanMinutes() -> Int {
        switch currentWeek?.weekNumber {
        case 1:
            return 15
        case 2:
            return 18
        case 3:
            return 23
        case 4:
            return 30
        case 5:
            return 50
        case 6:
            return 60
        default:
            return 75
        }
    }

    private func extractMinutes(
        from frequency: FrequencyType,
        isUsingBeginnerPlan: Bool
    ) -> Int {
        var result: Int = 0
        var baseMinute: Int = 0

        if isUsingBeginnerPlan {
            baseMinute = beginnerPlanMinutes()
        } else {
            baseMinute = 75
        }
        switch frequency {
        case .oneDay:
            result = baseMinute / 1
        case .twoDays:
            result = baseMinute / 2
        case .threeDays:
            result = baseMinute / 3
        case .fourDays:
            result = baseMinute / 4
        case .fiveDays:
            result = baseMinute / 5
        }
        return result
    }
}
