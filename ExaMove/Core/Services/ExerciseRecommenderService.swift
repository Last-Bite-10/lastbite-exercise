//
//  ExerciseRecommender.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

final class ExerciseRecommenderService {
    private var exercises: [Exercise] = []
    private var feedbackData: [FeedbackRecord] = []

    init() {
        exercises = Exercise.loadExercises()
    }

    func loadFeedback(_ feedback: [FeedbackRecord]) {
        self.feedbackData = feedback
    }

    func recommend(
        equipments: [EquipmentType],
        location: LocationType,
    ) -> [(Exercise, Double)] {
        var scores: [(Exercise, Double)] = []

        for exercise in exercises {
            var score = 0.0

            // Equipment matching
            if exercise.equipment == .none && equipments.contains(.none) {
                score += 3.0
            } else if equipments.contains(exercise.equipment) {
                score += 5.0
            }

            // Location matching
            if location == exercise.location {
                score += 2.0
            }

            // Apply feedback learning
            score += calculateFeedbackBonus(
                exercise: exercise,
                equipments: equipments,
                location: location,
            )

            scores.append((exercise, score))
        }

        return scores.sorted { $0.1 > $1.1 }
    }

    private func calculateFeedbackBonus(
        exercise: Exercise,
        equipments: [EquipmentType],
        location: LocationType,
    ) -> Double {
        var bonus = 0.0

        let relevantFeedback = feedbackData.filter {
            $0.exercise == exercise
        }

        for feedback in relevantFeedback {
            var similarity = 0.0

            if feedback.equipments.contains(where: { equipments.contains($0) })
            {
                similarity += 1.0
            }
            if feedback.location == location {
                similarity += 1.0
            }

            if feedback.wasGood == true {
                bonus += similarity * 1.5
            } else {
                bonus -= similarity * 0.5
            }
        }

        return bonus
    }
}
