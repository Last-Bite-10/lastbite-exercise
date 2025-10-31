//
//  ExerciseRecommender.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 30/10/25.
//

protocol ExerciseRecommenderProtocol {
    func loadFeedback(_ feedback: [FeedbackRecord])
    func recommend(equipment: [EquipmentType], location: LocationType) -> [(Exercise, Double)]
}

class ExerciseRecommender: ExerciseRecommenderProtocol {
    private var exercises: [Exercise] = []
    private var feedbackData: [FeedbackRecord] = []

    init() {
        exercises = Exercise.loadExercises()
    }

    func loadFeedback(_ feedback: [FeedbackRecord]) {
        self.feedbackData = feedback
    }

    // MARK: - Refactored Function
    
    /// Merekomendasikan latihan berdasarkan equipment dan lokasi yang sekarang menggunakan Enum.
    func recommend(
        equipment: [EquipmentType], // DIUBAH: dari String ke [EquipmentType]
        location: LocationType     // DIUBAH: dari String ke LocationType
    ) -> [(Exercise, Double)] {
        var scores: [(Exercise, Double)] = []

        for exercise in exercises {
            var score = 0.0

            // Equipment matching (Logika Baru)
            if exercise.equipment == .noEquipment {
                // Latihan "No equipment" selalu menjadi pilihan.
                score += 3.0
            } else if equipment.contains(exercise.equipment) {
                // Pengguna memiliki equipment spesifik yang dibutuhkan latihan.
                score += 5.0
            }

            // Location matching (Logika Baru)
            // Memeriksa kompatibilitas antara preferensi lokasi pengguna dan lokasi latihan.
            switch location { // Preferensi pengguna saat ini
            case .indoor:
                if exercise.location == .indoor || exercise.location == .both {
                    score += 2.0
                }
            case .outdoor:
                if exercise.location == .outdoor || exercise.location == .both {
                    score += 2.0
                }
            case .both:
                // Jika pengguna terbuka untuk keduanya, semua lokasi latihan cocok.
                score += 2.0
            }

            // Apply feedback learning (Parameter diperbarui)
            score += calculateFeedbackBonus(
                exercise: exercise,
                equipment: equipment, // DIUBAH
                location: location    // DIUBAH
            )

            scores.append((exercise, score))
        }

        return scores.sorted { $0.1 > $1.1 }
    }

    // MARK: - Refactored Helper
    
    /// Menghitung bonus skor berdasarkan riwayat feedback, sekarang menggunakan Enum.
    private func calculateFeedbackBonus(
        exercise: Exercise,
        equipment: [EquipmentType], // DIUBAH
        location: LocationType     // DIUBAH
    ) -> Double {
        var bonus = 0.0

        let relevantFeedback = feedbackData.filter {
            $0.exerciseId == exercise.id
        }

        for feedback in relevantFeedback {
            var similarity = 0.0

            // Equipment similarity (Logika Baru)
            // Memeriksa apakah equipment yang digunakan di feedback tersedia sekarang.
            if equipment.contains(feedback.equipmentAvailable) {
                similarity += 1.0
            } else if feedback.equipmentAvailable == .noEquipment {
                // Feedback "No equipment" selalu relevan.
                similarity += 1.0
            }
            
            // Location similarity (Logika Baru)
            // Memeriksa kompatibilitas lokasi feedback dengan lokasi pengguna saat ini.
            var locationMatch = false
            switch location { // Preferensi pengguna saat ini
            case .indoor:
                if feedback.location == .indoor || feedback.location == .both {
                    locationMatch = true
                }
            case .outdoor:
                if feedback.location == .outdoor || feedback.location == .both {
                    locationMatch = true
                }
            case .both:
                // Jika pengguna terbuka untuk keduanya, semua lokasi feedback relevan.
                locationMatch = true
            }
            
            if locationMatch {
                similarity += 1.0
            }

            // Apply bonus/penalty
            if feedback.wasGood {
                bonus += similarity * 1.5
            } else {
                bonus -= similarity * 0.5
            }
        }

        return bonus
    }
}
