//
//  TFIDFRecommender.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 30/10/25.
//

class TFIDFRecommender {
    private var exercises: [Exercise] = []
    private var feedbackData: [FeedbackRecord] = []

    init() {
        exercises = Exercise.loadExercises()
    }

    func loadFeedback(_ feedback: [FeedbackRecord]) {
        self.feedbackData = feedback
    }

    func recommend(
        equipmentAvailable: String,
        location: String,
    ) -> [(Exercise, Double)] {
        var scores: [(Exercise, Double)] = []

        for exercise in exercises {
            var score = 0.0

            // Equipment matching
            let equip = equipmentAvailable.lowercased()
            let exerciseEquip = exercise.equipment.lowercased()

            if exerciseEquip.contains("no equipment")
                && (equip.isEmpty || equip.contains("none"))
            {
                score += 3.0
            } else if !exerciseEquip.contains("no equipment")
                && equip.contains(exerciseEquip)
            {
                score += 5.0
            }

            // Location matching
            let loc = location.lowercased()
            if exercise.location.lowercased().contains(loc) {
                score += 2.0
            }

            // Apply feedback learning
            score += calculateFeedbackBonus(
                exercise: exercise,
                equipmentAvailable: equipmentAvailable,
                location: location,
            )

            scores.append((exercise, score))
        }

        return scores.sorted { $0.1 > $1.1 }
    }

    private func calculateFeedbackBonus(
        exercise: Exercise,
        equipmentAvailable: String,
        location: String,
    ) -> Double {
        var bonus = 0.0

        let relevantFeedback = feedbackData.filter {
            $0.exerciseId == exercise.id
        }

        for feedback in relevantFeedback {
            var similarity = 0.0

            if feedback.equipmentAvailable.lowercased().contains(
                equipmentAvailable.lowercased()
            ) {
                similarity += 1.0
            }
            if feedback.location.lowercased() == location.lowercased() {
                similarity += 1.0
            }

            if feedback.wasGood {
                bonus += similarity * 1.5
            } else {
                bonus -= similarity * 0.5
            }
        }

        return bonus
    }
}
