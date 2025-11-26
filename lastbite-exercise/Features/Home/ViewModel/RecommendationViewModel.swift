//
//  CoreViewModel.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 30/10/25.
//

import SwiftData
import SwiftUI

@Observable
final class RecommendationViewModel {
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
        let today = calendar.startOfDay(for: Date())

        // If we have a previous week
        if let latestWeek = weeklies?.first {
            let start = calendar.startOfDay(for: latestWeek.startDate)
            let end = calendar.startOfDay(
                for: latestWeek.endDate ?? start.addingTimeInterval(6 * 86400)
            )

            // Check if today is inside custom week range
            if today >= start && today <= end {
                currentWeek = latestWeek
                return
            }

            // Otherwise create a new week starting the next day after the last ends
            let newStart = calendar.date(byAdding: .day, value: 1, to: end)!

            let newWeek = Weekly(
                weekNumber: latestWeek.weekNumber + 1,
                startDate: newStart
            )
            context.insert(newWeek)
            try? context.save()
            currentWeek = newWeek
            return
        }

        // No previous week → first launch
        let start = today

        let firstWeek = Weekly(
            weekNumber: 1,
            startDate: start,
        )

        context.insert(firstWeek)
        try? context.save()
        currentWeek = firstWeek
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
        let topExercises = recommendations.prefix(
            getRecommendedPrefix(frequency: preference.frequency ?? .oneDay)
        )

        let minutes = extractMinutes(
            from: preference.frequency ?? .oneDay,
            isUsingBeginnerPlan: preference.planChosen == .beginner
        )

        // Insert exercise records into the context
        var dayOffset = 0

        for (index, (exercise, _)) in topExercises.enumerated() {
            if index % 2 == 0 && index != 0 {
                dayOffset += 1
            }

            let usedAtDate = Calendar.current.date(
                byAdding: .day,
                value: dayOffset,
                to: Date()
            )!

            let record = ExerciseRecord(
                exercise: exercise,
                requiredSeconds: minutes * 60,
                usedAt: usedAtDate,
                week: week
            )

            context.insert(record)
            week.records!.append(record)
        }

        try? context.save()
    }

    func modifyExerciseRecords(records: [ExerciseRecord], usedAt: Date = Date())
    {
        guard let context = modelContext else { return }

        currentWeek?.records?.removeAll(where: { existing in
            Calendar.current.isDate(existing.usedAt!, inSameDayAs: usedAt)
        })

        currentWeek?.records?.append(contentsOf: records)
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

    private func getRecommendedPrefix(frequency: FrequencyType) -> Int {
        switch frequency {
        case .oneDay: return 2
        case .twoDays: return 4
        case .threeDays: return 6
        case .fourDays: return 8
        case .fiveDays: return 10
        }
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
