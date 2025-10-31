//
//  RecommendationViewModel.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 30/10/25.
//

import SwiftData
import SwiftUI

@Observable
class RecommendationViewModel {
    var currentWeek: Weekly?
    var showSettings = false

    private var modelContext: ModelContext?
    
    // 1. UBAH INI: dari 'let' menjadi 'var' dan tipe 'Protocol'
    private var recommender: ExerciseRecommenderProtocol

    // 2. BUAT INIT BARU: untuk menyuntikkan dependensi
    init(recommender: ExerciseRecommenderProtocol = ExerciseRecommender()) {
        self.recommender = recommender
    }

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
            // (Note: Logic untuk endOfWeek tidak digunakan, tapi dibiarkan)
            let endOfWeek = calendar.date(
                byAdding: .day,
                value: 6,
                to: startOfWeek
            )!

            let newWeek = Weekly(
                weekNumber: weekNumber,
                startDate: startOfWeek,
            )
            context.insert(newWeek)
            try? context.save()
            currentWeek = newWeek
        }
    }

    // MARK: - Refactored Function
    
    func initializeWeeklyExercises(preference: Preference) {
        guard let context = modelContext,
              let week = currentWeek,
              week.records.isEmpty
        else { return }

        // DIPERBARUI: Kita perlu lokasi yang valid untuk recommender baru.
        guard let userLocation = preference.location else {
            print("Rekomendasi dibatalkan: Preferensi lokasi pengguna belum diatur.")
            return
        }

        // Load feedback data
        let feedbackDescriptor = FetchDescriptor<FeedbackRecord>()
        let feedbackRecords = try? context.fetch(feedbackDescriptor)

        if let feedbacks = feedbackRecords {
            recommender.loadFeedback(feedbacks)
        }

        // Get recommendations (Logika kotor dihapus)
        let recommendations = recommender.recommend(
            equipment: preference.equipmentAvailable, // DIUBAH: Dilewatkan langsung
            location: userLocation                  // DIUBAH: Dilewatkan langsung
        )

        // Create 2 exercise records for this week
        let topExercises = recommendations.prefix(2)
        let minutes = extractMinutes(from: preference.frequency ?? .oneDay)

        for (exercise, _) in topExercises {
            let record = ExerciseRecord(
                exerciseName: exercise.name,
                exerciseId: exercise.id,
                requiredMinutes: minutes,
                week: week
            )
            context.insert(record)
            week.records.append(record)

            print("Inserted exercise: \(exercise.name) with \(minutes) minutes")
        }

        try? context.save()
    }

    func completeExercise(record: ExerciseRecord, minutes: Int) {
        guard let context = modelContext else { return }

        // (Catatan: Logic ini mungkin perlu dijalankan setelah 'record.isCompleted' di-set)
        // Check if all exercises in the week are completed
        if let week = currentWeek {
            let allCompleted = week.records.allSatisfy { $0.isCompleted }
            week.isCompleted = allCompleted
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
