//
//  Exercise.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 30/10/25.
//

struct Exercise {
    let id: Int
    let name: String
    let location: String
    let needsTutorial: Bool
    let equipment: String
    let weather: String

    public static func loadExercises() -> [Exercise] {
        return [
            Exercise(
                id: 1,
                name: "Brisk walking",
                location: "Outdoor",
                needsTutorial: false,
                equipment: "No equipment",
                weather: "Clear weather"
            ),
            Exercise(
                id: 2,
                name: "Push up",
                location: "Indoor",
                needsTutorial: true,
                equipment: "No equipment",
                weather: "Clear weather"
            ),
            Exercise(
                id: 3,
                name: "Invisible jump rope",
                location: "Indoor",
                needsTutorial: true,
                equipment: "No equipment",
                weather: "Clear weather"
            ),
            Exercise(
                id: 4,
                name: "Vertical jump",
                location: "Indoor",
                needsTutorial: true,
                equipment: "No equipment",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 5,
                name: "Butt kicks",
                location: "Indoor/Outdoor",
                needsTutorial: true,
                equipment: "No equipment",
                weather: "Clear weather"
            ),
            Exercise(
                id: 6,
                name: "Bodyweight squats",
                location: "Indoor",
                needsTutorial: true,
                equipment: "No equipment",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 7,
                name: "March in place",
                location: "Indoor",
                needsTutorial: true,
                equipment: "No equipment",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 8,
                name: "Skipping",
                location: "Indoor/Outdoor",
                needsTutorial: true,
                equipment: "Jump Rope",
                weather: "Clear weather"
            ),
            Exercise(
                id: 9,
                name: "Plank shoulder tap",
                location: "Indoor",
                needsTutorial: true,
                equipment: "Exercise mat",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 10,
                name: "Dumbbell deadlift",
                location: "Indoor",
                needsTutorial: true,
                equipment: "Dumbbell",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 11,
                name: "Stair climbing",
                location: "Indoor",
                needsTutorial: false,
                equipment: "Stairs",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 12,
                name: "Wall sit",
                location: "Indoor",
                needsTutorial: false,
                equipment: "Wall surface",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 13,
                name: "Frog Jumps",
                location: "Indoor",
                needsTutorial: true,
                equipment: "No equipment",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 14,
                name: "Slow mountain climbers",
                location: "Indoor",
                needsTutorial: true,
                equipment: "Exercise Mat",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 15,
                name: "Squat jump",
                location: "Indoor",
                needsTutorial: true,
                equipment: "No equipment",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 16,
                name: "Jumping jacks",
                location: "Indoor/Outdoor",
                needsTutorial: false,
                equipment: "No equipment",
                weather: "Clear weather"
            ),
            Exercise(
                id: 17,
                name: "Jog in place",
                location: "Indoor",
                needsTutorial: false,
                equipment: "No equipment",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 18,
                name: "Bicep curl",
                location: "Indoor",
                needsTutorial: true,
                equipment: "Dumbbell",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 19,
                name: "Dumbbell thruster",
                location: "Indoor",
                needsTutorial: true,
                equipment: "Dumbbell",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 20,
                name: "Lunges",
                location: "Indoor/Outdoor",
                needsTutorial: false,
                equipment: "No equipment",
                weather: "Clear weather"
            ),
            Exercise(
                id: 21,
                name: "Badminton",
                location: "Outdoor",
                needsTutorial: false,
                equipment: "Racket",
                weather: "No strong wind"
            ),
            Exercise(
                id: 22,
                name: "Basketball",
                location: "Outdoor",
                needsTutorial: false,
                equipment: "Ball",
                weather: "Avoid rain"
            ),
            Exercise(
                id: 23,
                name: "Cycling",
                location: "Outdoor",
                needsTutorial: false,
                equipment: "Bicycle",
                weather: "Clear weather"
            ),
            Exercise(
                id: 24,
                name: "Tennis",
                location: "Outdoor",
                needsTutorial: false,
                equipment: "Paddle tennis",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 25,
                name: "Volleyball",
                location: "Outdoor",
                needsTutorial: false,
                equipment: "Volleyball",
                weather: "Avoid strong wind"
            )
        ]
    }
}
