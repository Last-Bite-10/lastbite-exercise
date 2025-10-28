//
//  TFIDFRecommender.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 28/10/25.
//

import SwiftUI

@Observable class TFIDFRecommenderViewModel {
    var preference: Preference
    var exercises: [Exercise] = []
    var documentFrequency: [String: Int] = [:]
    var totalDocuments: Int = 0
    var recommendedExercises: [Exercise] = []

    init(_ preference: Preference) {
        self.preference = preference
        loadExercises()
        buildTFIDFModel()
        recommendedExercises = recommend(
            equipmentAvailable: preference.equipments,
            location: preference.location,
            weather: "Clear"
        )
        .prefix(2)
        .map { $0.0 }
    }

    // MARK: - Load Exercise Data
    private func loadExercises() {
        exercises = [
            Exercise(
                id: 1,
                name: "Brisk walking",
                location: .outdoor,
                equipment: .none,
                weather: "Clear weather"
            ),
            Exercise(
                id: 2,
                name: "Push up",
                location: .indoor,
                equipment: .none,
                weather: "Clear weather"
            ),
            Exercise(
                id: 3,
                name: "Invisible jump rope",
                location: .indoor,
                equipment: .none,
                weather: "Clear weather"
            ),
            Exercise(
                id: 4,
                name: "Vertical jump",
                location: .indoor,
                equipment: .none,
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 5,
                name: "Butt kicks",
                location: .both,
                equipment: .none,
                weather: "Clear weather"
            ),
            Exercise(
                id: 6,
                name: "Bodyweight squats",
                location: .indoor,
                equipment: .none,
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 7,
                name: "March in place",
                location: .indoor,
                equipment: .none,
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 8,
                name: "Skipping",
                location: .both,
                equipment: .jumpRope,
                weather: "Clear weather"
            ),
            Exercise(
                id: 9,
                name: "Plank shoulder tap",
                location: .indoor,
                equipment: .exerciseMat,
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 10,
                name: "Dumbbell deadlift",
                location: .indoor,
                equipment: .dumbbell,
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 11,
                name: "Stair climbing",
                location: .indoor,
                equipment: .stairs,
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 12,
                name: "Wall sit",
                location: .indoor,
                equipment: .wallSurface,
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 13,
                name: "Frog Jumps",
                location: .indoor,
                equipment: .none,
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 14,
                name: "Slow mountain climbers",
                location: .indoor,
                equipment: .exerciseMat,
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 15,
                name: "Squat jump",
                location: .indoor,
                equipment: .none,
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 16,
                name: "Jumping jacks",
                location: .both,
                equipment: .none,
                weather: "Clear weather"
            ),
            Exercise(
                id: 17,
                name: "Jog in place",
                location: .indoor,
                equipment: .none,
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 18,
                name: "Bicep curl",
                location: .indoor,
                equipment: .dumbbell,
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 19,
                name: "Dumbbell thruster",
                location: .indoor,
                equipment: .dumbbell,
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 20,
                name: "Lunges",
                location: .both,
                equipment: .none,
                weather: "Clear weather"
            ),
            Exercise(
                id: 21,
                name: "Badminton",
                location: .outdoor,
                equipment: .racket,
                weather: "No strong wind"
            ),
            Exercise(
                id: 22,
                name: "Jogging",
                location: .outdoor,
                equipment: .none,
                weather: "Avoid rain"
            ),
            Exercise(
                id: 23,
                name: "Cycling",
                location: .outdoor,
                equipment: .bicycle,
                weather: "Clear weather"
            ),
            Exercise(
                id: 24,
                name: "Tennis",
                location: .outdoor,
                equipment: .paddleTennis,
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 25,
                name: "Volleyball",
                location: .outdoor,
                equipment: .volleyball,
                weather: "Avoid strong wind"
            ),
        ]
    }

    // MARK: - Build TF-IDF Model
    private func buildTFIDFModel() {
        totalDocuments = exercises.count
        documentFrequency = [:]

        // Build document frequency map
        for exercise in exercises {
            let terms = extractTerms(from: exercise)
            let uniqueTerms = Set(terms)

            for term in uniqueTerms {
                documentFrequency[term, default: 0] += 1
            }
        }
    }

    private func extractTerms(from exercise: Exercise) -> [String] {
        var terms: [String] = []

        // Tokenize and normalize
        terms += tokenize(exercise.location.rawValue)
        terms += tokenize(exercise.equipment.rawValue)
        terms += tokenize(exercise.weather)

        return terms
    }

    private func tokenize(_ text: String) -> [String] {
        return text.lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
    }

    // MARK: - TF-IDF Calculation
    private func calculateTFIDF(query: [String], document: [String]) -> Double {
        var score = 0.0
        let documentTermCount = document.count

        for queryTerm in query {
            // Term Frequency (TF)
            let termCount = document.filter { $0 == queryTerm }.count
            let tf = Double(termCount) / Double(documentTermCount)

            // Inverse Document Frequency (IDF)
            let df = documentFrequency[queryTerm] ?? 0
            let idf = df > 0 ? log(Double(totalDocuments) / Double(df)) : 0

            // TF-IDF
            score += tf * idf
        }

        return score
    }

    // MARK: - Recommendation
    func recommend(
        equipmentAvailable: [EquipmentType],
        location: LocationType,
        weather: String,
    ) -> [(Exercise, Double)] {
        // Extract query terms
        var queryTerms: [String] = []
        queryTerms += equipmentAvailable.flatMap { tokenize($0.rawValue) }
        queryTerms += tokenize(location.rawValue)
        queryTerms += tokenize(weather)

        // Calculate TF-IDF scores
        var scores: [(Exercise, Double)] = []

        for exercise in exercises {
            let documentTerms = extractTerms(from: exercise)
            var tfidfScore = calculateTFIDF(
                query: queryTerms,
                document: documentTerms
            )

            // Add exact match bonuses
            tfidfScore += calculateExactMatchBonus(
                exercise: exercise,
                equipmentAvailable: equipmentAvailable,
                location: location,
                weather: weather,
            )

            // Apply user feedback learning
            //            tfidfScore += calculateFeedbackBonus(
            //                exercise: exercise,
            //                equipmentAvailable: equipmentAvailable,
            //                location: location,
            //                weather: weather
            //            )

            scores.append((exercise, tfidfScore))
        }

        // Normalize scores to 0-1 range
        let maxScore = scores.map { $0.1 }.max() ?? 1.0
        let normalizedScores = scores.map { ($0.0, $0.1 / maxScore) }

        // Sort by score
        return normalizedScores.sorted { $0.1 > $1.1 }
    }

    private func calculateExactMatchBonus(
        exercise: Exercise,
        equipmentAvailable: [EquipmentType],
        location: LocationType,
        weather: String,
    ) -> Double {
        var bonus = 0.0

        // Equipment match
        let equip = equipmentAvailable
        let exerciseEquip = exercise.equipment

        if exerciseEquip == .none && equip.isEmpty {
            bonus += 2.0
        } else if exerciseEquip != .none {
            let equipTokens = equip.flatMap { tokenize($0.rawValue) }
            let exerciseEquipTokens = tokenize(exerciseEquip.rawValue)
            for token in equipTokens {
                if exerciseEquipTokens.contains(token) {
                    bonus += 3.0
                }
            }
        }

        // Location match
        let loc = location.rawValue
        let exerciseLoc = exercise.location.rawValue
        if exerciseLoc.contains(loc) || loc.contains(exerciseLoc) {
            bonus += 2.0
        }

        // Weather match
        let weath = weather.lowercased()
        let exerciseWeather = exercise.weather.lowercased()

        if exerciseWeather.contains("not affected") {
            bonus += 1.0
        } else if weath.contains("clear") && exerciseWeather.contains("clear") {
            bonus += 1.5
        } else if weath.contains("rain") && exerciseWeather.contains("rain") {
            bonus += 1.5
        } else if weath.contains("wind") && exerciseWeather.contains("wind") {
            bonus += 1.5
        }

        return bonus
    }
}
