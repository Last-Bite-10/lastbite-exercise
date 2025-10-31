//
//  Exercise.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 30/10/25.
//

struct Exercise {
    let id: Int
    let name: String
    let location: LocationType     // DIUBAH
    let needsTutorial: Bool
    let equipment: EquipmentType   // DIUBAH
    let weather: String

    public static func loadExercises() -> [Exercise] {
        return [
            Exercise(
                id: 1,
                name: "Brisk walking",
                location: .outdoor,        // Diperbarui
                needsTutorial: false,
                equipment: .noEquipment,   // Diperbarui
                weather: "Clear weather"
            ),
            Exercise(
                id: 2,
                name: "Push up",
                location: .indoor,         // Diperbarui
                needsTutorial: true,
                equipment: .noEquipment,   // Diperbarui
                weather: "Clear weather"
            ),
            Exercise(
                id: 3,
                name: "Invisible jump rope",
                location: .indoor,         // Diperbarui
                needsTutorial: true,
                equipment: .noEquipment,   // Diperbarui
                weather: "Clear weather"
            ),
            Exercise(
                id: 4,
                name: "Vertical jump",
                location: .indoor,         // Diperbarui
                needsTutorial: true,
                equipment: .noEquipment,   // Diperbarui
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 5,
                name: "Butt kicks",
                location: .both,           // Diperbarui dari "Indoor/Outdoor"
                needsTutorial: true,
                equipment: .noEquipment,   // Diperbarui
                weather: "Clear weather"
            ),
            Exercise(
                id: 6,
                name: "Bodyweight squats",
                location: .indoor,         // Diperbarui
                needsTutorial: true,
                equipment: .noEquipment,   // Diperbarui
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 7,
                name: "March in place",
                location: .indoor,         // Diperbarui
                needsTutorial: true,
                equipment: .noEquipment,   // Diperbarui
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 8,
                name: "Skipping",
                location: .both,           // Diperbarui dari "Indoor/Outdoor"
                needsTutorial: true,
                equipment: .jumpRope,      // Diperbarui
                weather: "Clear weather"
            ),
            Exercise(
                id: 9,
                name: "Plank shoulder tap",
                location: .indoor,         // Diperbarui
                needsTutorial: true,
                equipment: .exerciseMat,   // Diperbarui (string "Exercise mat" dikonversi)
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 10,
                name: "Dumbbell deadlift",
                location: .indoor,         // Diperbarui
                needsTutorial: true,
                equipment: .dumbbell,      // Diperbarui
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 11,
                name: "Stair climbing",
                location: .indoor,         // Diperbarui
                needsTutorial: false,
                equipment: .stairs,        // Diperbarui
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 12,
                name: "Wall sit",
                location: .indoor,         // Diperbarui
                needsTutorial: false,
                equipment: .wallSurface,   // Diperbarui (string "Wall surface" dikonversi)
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 13,
                name: "Frog Jumps",
                location: .indoor,         // Diperbarui
                needsTutorial: true,
                equipment: .noEquipment,   // Diperbarui
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 14,
                name: "Slow mountain climbers",
                location: .indoor,         // Diperbarui
                needsTutorial: true,
                equipment: .exerciseMat,   // Diperbarui
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 15,
                name: "Squat jump",
                location: .indoor,         // Diperbarui
                needsTutorial: true,
                equipment: .noEquipment,   // Diperbarui
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 16,
                name: "Jumping jacks",
                location: .both,           // Diperbarui dari "Indoor/Outdoor"
                needsTutorial: false,
                equipment: .noEquipment,   // Diperbarui
                weather: "Clear weather"
            ),
            Exercise(
                id: 17,
                name: "Jog in place",
                location: .indoor,         // Diperbarui
                needsTutorial: false,
                equipment: .noEquipment,   // Diperbarui
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 18,
                name: "Bicep curl",
                location: .indoor,         // Diperbarui
                needsTutorial: true,
                equipment: .dumbbell,      // Diperbarui
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 19,
                name: "Dumbbell thruster",
                location: .indoor,         // Diperbarui
                needsTutorial: true,
                equipment: .dumbbell,      // Diperbarui
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 20,
                name: "Lunges",
                location: .both,           // Diperbarui dari "Indoor/Outdoor"
                needsTutorial: false,
                equipment: .noEquipment,   // Diperbarui
                weather: "Clear weather"
            ),
            Exercise(
                id: 21,
                name: "Badminton",
                location: .outdoor,        // Diperbarui
                needsTutorial: false,
                equipment: .racket,        // Diperbarui
                weather: "No strong wind"
            ),
            Exercise(
                id: 22,
                name: "Basketball",
                location: .outdoor,        // Diperbarui
                needsTutorial: false,
                equipment: .ball,          // Diperbarui (menggunakan case .ball yang baru)
                weather: "Avoid rain"
            ),
            Exercise(
                id: 23,
                name: "Cycling",
                location: .outdoor,        // Diperbarui
                needsTutorial: false,
                equipment: .bicycle,       // Diperbarui
                weather: "Clear weather"
            ),
            Exercise(
                id: 24,
                name: "Tennis",
                location: .outdoor,        // Diperbarui
                needsTutorial: false,
                equipment: .paddleTennis,  // Diperbarui (string "Paddle tennis" dikonversi)
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 25,
                name: "Volleyball",
                location: .outdoor,        // Diperbarui
                needsTutorial: false,
                equipment: .volleyball,    // Diperbarui
                weather: "Avoid strong wind"
            )
        ]
    }
}
