//
//  Recommender.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 30/10/25.
//

import Foundation

class ExerciseRecommender {
    private var exercises: [Exercise] = []
    private var feedbackData: [FeedbackRecord] = []

    static let shared = ExerciseRecommender()

    init() {
        exercises = Exercise.loadExercises()
    }

    func loadFeedback(_ feedback: [FeedbackRecord]) {
        self.feedbackData = feedback
    }

    func recommend(
        equipments: [EquipmentType],
        location: LocationType,
        currentWeather: WeatherType
    ) -> [(Exercise, Double)] {
        
        var scoredExercises: [(Exercise, Double)] = []
        
        let wWeather: Double = 0.40
        let wEquipment: Double = 0.35
        let wLocation: Double = 0.15
        let wHistory: Double = 0.10

        for exercise in exercises {
            let weatherScore = calculateWeatherScore(exercise: exercise, currentWeather: currentWeather)
            
            let equipmentScore = calculateEquipmentScore(exercise: exercise, userEquipments: equipments)
            
            let locationScore = calculateLocationScore(exercise: exercise, userLocation: location)
            
            let historyScore = calculateHistoryScore(exercise: exercise)
            
            let finalScore = (weatherScore * wWeather) +
                             (equipmentScore * wEquipment) +
                             (locationScore * wLocation) +
                             (historyScore * wHistory)
            
            if finalScore > 0.1 {
                scoredExercises.append((exercise, finalScore))
            }
        }

        return scoredExercises.sorted { $0.1 > $1.1 }
    }
    
    // MARK: - HELPER CALCULATION FUNCTIONS (NORMALIZATION)
    private func calculateWeatherScore(exercise: Exercise, currentWeather: WeatherType) -> Double {
        
        // Blocker
        if currentWeather == .rainy && exercise.location == .outdoor {
            return 0.0 // Rain & Outdoor = Impossible to recommend
        }
        
        if currentWeather == .extremeHeat && exercise.location == .outdoor {
            return 0.2 // Too hot & Outdoor = Not recommended but not impossible
        }
        
        if currentWeather == .strongWind && (exercise.weather == .avoidStrongWind || exercise.weather == .noStrongWind) { // swiftlint:disable:this line_length
            return 0.0 // Strong wind & badminton/volley = Impossible
        }
        
        // Ideal Weather
        if currentWeather == .clear && exercise.location == .outdoor {
            return 1.0 // Clear + Outdoor = Very recommended
        }
        
        // Neutral for indoor
        return 1.0
    }
    
    private func calculateEquipmentScore(exercise: Exercise, userEquipments: [EquipmentType]) -> Double {
        if exercise.equipment == .none {
            return 0.9
        }
        
        if userEquipments.contains(exercise.equipment) {
            return 1.0
        }
        
        return 0.0
    }
    
    private func calculateLocationScore(exercise: Exercise, userLocation: LocationType) -> Double {
        if userLocation == exercise.location {
            return 1.0
        }
        
        if userLocation == .both {
            return 1.0
        }
        
        return 0.2
    }
    
    private func calculateHistoryScore(exercise: Exercise) -> Double {
        let relatedHistory = feedbackData.filter { $0.exercise == exercise }
        
        if relatedHistory.isEmpty {
            return 0.6
        }
        
        let completedCount = Double(relatedHistory.filter { $0.isCompleted }.count)
        let totalAssigned = Double(relatedHistory.count)
        
        let completionRate = completedCount / totalAssigned
        
        return completionRate
    }
}
