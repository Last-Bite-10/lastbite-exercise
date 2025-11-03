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
    private let recommender = TFIDFRecommender()

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
            equipmentAvailable: preference.equipmentAvailable.map {
                $0.rawValue
            }.joined(separator: " "),
            location: preference.location?.rawValue ?? "",
        )

        // Create 2 exercise records for this week
        let topExercises = recommendations.prefix(2)
        let minutes = extractMinutes(from: preference.frequency ?? .oneDay)

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

    private func baseMinutes() -> Int {
        switch currentWeek?.weekNumber {
        case 1:
            return 30
        case 2:
            return 36
        case 3:
            return 45
        case 4:
            return 60
        case 5:
            return 100
        case 6:
            return 120
        default:
            return 150
        }
    }

    private func extractMinutes(from frequency: FrequencyType) -> Int {
        switch frequency {
        case .oneDay:
            baseMinutes() / 1
        case .twoDays:
            baseMinutes() / 2
        case .threeDays:
            baseMinutes() / 3
        case .fourDays:
            baseMinutes() / 4
        case .fiveDays:
            baseMinutes() / 5

        }
    }
}
