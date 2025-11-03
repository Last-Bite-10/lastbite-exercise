//
//  Exercise.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 30/10/25.
//

struct Exercise: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let imageName: String?
    let location: String
    let needsTutorial: Bool
    let equipment: String
    let weather: String

    public static func loadExercises() -> [Exercise] {
        return [
            Exercise(
                id: 1,
                name: "Brisk walking",
                imageName: "brisk-walking",
                location: "Outdoor",
                needsTutorial: false,
                equipment: "No equipment",
                weather: "Clear weather"
            ),
            Exercise(
                id: 2,
                name: "Push up",
                imageName: "push-up",
                location: "Indoor",
                needsTutorial: true,
                equipment: "No equipment",
                weather: "Clear weather"
            ),
            Exercise(
                id: 3,
                name: "Invisible jump rope",
                imageName: "invisible-jump-rope",
                location: "Indoor",
                needsTutorial: true,
                equipment: "No equipment",
                weather: "Clear weather"
            ),
            Exercise(
                id: 4,
                name: "Vertical jump",
                imageName: "vertical-jump",
                location: "Indoor",
                needsTutorial: true,
                equipment: "No equipment",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 5,
                name: "Butt kicks",
                imageName: "butt-kicks",
                location: "Indoor/Outdoor",
                needsTutorial: true,
                equipment: "No equipment",
                weather: "Clear weather"
            ),
            Exercise(
                id: 6,
                name: "Bodyweight squats",
                imageName: "bodyweight-squats",
                location: "Indoor",
                needsTutorial: true,
                equipment: "No equipment",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 7,
                name: "March in place",
                imageName: "march-in-place",
                location: "Indoor",
                needsTutorial: true,
                equipment: "No equipment",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 8,
                name: "Skipping",
                imageName: "skipping",
                location: "Indoor/Outdoor",
                needsTutorial: true,
                equipment: "Jump Rope",
                weather: "Clear weather"
            ),
            Exercise(
                id: 9,
                name: "Plank shoulder tap",
                imageName: "plank-shoulder-tap",
                location: "Indoor",
                needsTutorial: true,
                equipment: "Exercise mat",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 10,
                name: "Dumbbell deadlift",
                imageName: "dumbbell-deadlift",
                location: "Indoor",
                needsTutorial: true,
                equipment: "Dumbbell",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 11,
                name: "Stair climbing",
                imageName: "stair-climbing",
                location: "Indoor",
                needsTutorial: false,
                equipment: "Stairs",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 12,
                name: "Wall sit",
                imageName: "wall-sit",
                location: "Indoor",
                needsTutorial: false,
                equipment: "Wall surface",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 13,
                name: "Frog Jumps",
                imageName: "frog-jumps",
                location: "Indoor",
                needsTutorial: true,
                equipment: "No equipment",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 14,
                name: "Slow mountain climbers",
                imageName: "slow-mountain-climbers",
                location: "Indoor",
                needsTutorial: true,
                equipment: "Exercise Mat",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 15,
                name: "Squat jump",
                imageName: "squat-jump",
                location: "Indoor",
                needsTutorial: true,
                equipment: "No equipment",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 16,
                name: "Jumping jacks",
                imageName: "jumping-jacks",
                location: "Indoor/Outdoor",
                needsTutorial: false,
                equipment: "No equipment",
                weather: "Clear weather"
            ),
            Exercise(
                id: 17,
                name: "Jog in place",
                imageName: "jog-in-place",
                location: "Indoor",
                needsTutorial: false,
                equipment: "No equipment",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 18,
                name: "Bicep curl",
                imageName: "bicep-curl",
                location: "Indoor",
                needsTutorial: true,
                equipment: "Dumbbell",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 19,
                name: "Dumbbell thruster",
                imageName: "dumbbell-thruster",
                location: "Indoor",
                needsTutorial: true,
                equipment: "Dumbbell",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 20,
                name: "Lunges",
                imageName: "lunges",
                location: "Indoor/Outdoor",
                needsTutorial: false,
                equipment: "No equipment",
                weather: "Clear weather"
            ),
            Exercise(
                id: 21,
                name: "Badminton",
                imageName: "badminton",
                location: "Outdoor",
                needsTutorial: false,
                equipment: "Racket",
                weather: "No strong wind"
            ),
            Exercise(
                id: 22,
                name: "Basketball",
                imageName: "basketball",
                location: "Outdoor",
                needsTutorial: false,
                equipment: "Ball",
                weather: "Avoid rain"
            ),
            Exercise(
                id: 23,
                name: "Cycling",
                imageName: "cycling",
                location: "Outdoor",
                needsTutorial: false,
                equipment: "Bicycle",
                weather: "Clear weather"
            ),
            Exercise(
                id: 24,
                name: "Tennis",
                imageName: "tennis",
                location: "Outdoor",
                needsTutorial: false,
                equipment: "Paddle tennis",
                weather: "Not affected by weather"
            ),
            Exercise(
                id: 25,
                name: "Volleyball",
                imageName: "volleyball",
                location: "Outdoor",
                needsTutorial: false,
                equipment: "Volleyball",
                weather: "Avoid strong wind"
            ),
        ]
    }
}
