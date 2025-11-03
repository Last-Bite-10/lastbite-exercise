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
    let location: LocationType
    let needsTutorial: Bool
    let equipment: EquipmentType
    let weather: WeatherType

    public static func loadExercises() -> [Exercise] {
        return [
            Exercise(
                id: 1,
                name: "Brisk walking",
                imageName: "brisk-walking",
                location: .outdoor,
                needsTutorial: false,
                equipment: .none,
                weather: .clear
            ),
            Exercise(
                id: 2,
                name: "Push up",
                imageName: "push-up",
                location: .indoor,
                needsTutorial: true,
                equipment: .none,
                weather: .clear
            ),
            Exercise(
                id: 3,
                name: "Invisible jump rope",
                imageName: "invisible-jump-rope",
                location: .indoor,
                needsTutorial: true,
                equipment: .none,
                weather: .clear
            ),
            Exercise(
                id: 4,
                name: "Vertical jump",
                imageName: "vertical-jump",
                location: .indoor,
                needsTutorial: true,
                equipment: .none,
                weather: .notAffected
            ),
            Exercise(
                id: 5,
                name: "Butt kicks",
                imageName: "butt-kicks",
                location: .both,
                needsTutorial: true,
                equipment: .none,
                weather: .clear
            ),
            Exercise(
                id: 6,
                name: "Bodyweight squats",
                imageName: "bodyweight-squats",
                location: .indoor,
                needsTutorial: true,
                equipment: .none,
                weather: .notAffected
            ),
            Exercise(
                id: 7,
                name: "March in place",
                imageName: "march-in-place",
                location: .indoor,
                needsTutorial: true,
                equipment: .none,
                weather: .notAffected
            ),
            Exercise(
                id: 8,
                name: "Skipping",
                imageName: "skipping",
                location: .both,
                needsTutorial: true,
                equipment: .jumpRope,
                weather: .clear
            ),
            Exercise(
                id: 9,
                name: "Plank shoulder tap",
                imageName: "plank-shoulder-tap",
                location: .indoor,
                needsTutorial: true,
                equipment: .exerciseMat,
                weather: .notAffected
            ),
            Exercise(
                id: 10,
                name: "Dumbbell deadlift",
                imageName: "dumbbell-deadlift",
                location: .indoor,
                needsTutorial: true,
                equipment: .dumbbell,
                weather: .notAffected
            ),
            Exercise(
                id: 11,
                name: "Stair climbing",
                imageName: "stair-climbing",
                location: .indoor,
                needsTutorial: false,
                equipment: .stairs,
                weather: .notAffected
            ),
            Exercise(
                id: 12,
                name: "Wall sit",
                imageName: "wall-sit",
                location: .indoor,
                needsTutorial: true,
                equipment: .wallSurface,
                weather: .notAffected
            ),
            Exercise(
                id: 13,
                name: "Frog jumps",
                imageName: "frog-jumps",
                location: .indoor,
                needsTutorial: true,
                equipment: .none,
                weather: .notAffected
            ),
            Exercise(
                id: 14,
                name: "Slow mountain climbers",
                imageName: "slow-mountain-climbers",
                location: .indoor,
                needsTutorial: true,
                equipment: .exerciseMat,
                weather: .notAffected
            ),
            Exercise(
                id: 15,
                name: "Squat jump",
                imageName: "squat-jump",
                location: .indoor,
                needsTutorial: true,
                equipment: .none,
                weather: .notAffected
            ),
            Exercise(
                id: 16,
                name: "Jumping jacks",
                imageName: "jumping-jacks",
                location: .both,
                needsTutorial: false,
                equipment: .none,
                weather: .clear
            ),
            Exercise(
                id: 17,
                name: "Jog in place",
                imageName: "jog-in-place",
                location: .indoor,
                needsTutorial: false,
                equipment: .none,
                weather: .notAffected
            ),
            Exercise(
                id: 18,
                name: "Bicep curl",
                imageName: "bicep-curl",
                location: .indoor,
                needsTutorial: true,
                equipment: .dumbbell,
                weather: .notAffected
            ),
            Exercise(
                id: 19,
                name: "Dumbbell thruster",
                imageName: "dumbbell-thruster",
                location: .indoor,
                needsTutorial: true,
                equipment: .dumbbell,
                weather: .notAffected
            ),
            Exercise(
                id: 20,
                name: "Lunge",
                imageName: "lunge",
                location: .both,
                needsTutorial: true,
                equipment: .none,
                weather: .clear
            ),
            Exercise(
                id: 21,
                name: "Badminton",
                imageName: "badminton",
                location: .outdoor,
                needsTutorial: false,
                equipment: .racket,
                weather: .noStrongWind
            ),
            Exercise(
                id: 22,
                name: "Jogging",
                imageName: "jogging",
                location: .outdoor,
                needsTutorial: false,
                equipment: .none,
                weather: .clear
            ),
            Exercise(
                id: 23,
                name: "Cycling",
                imageName: "cycling",
                location: .outdoor,
                needsTutorial: false,
                equipment: .bicycle,
                weather: .clear
            ),
            Exercise(
                id: 24,
                name: "Tennis",
                imageName: "tennis",
                location: .outdoor,
                needsTutorial: false,
                equipment: .paddleTennis,
                weather: .notAffected
            ),
            Exercise(
                id: 25,
                name: "Volleyball",
                imageName: "volleyball",
                location: .outdoor,
                needsTutorial: false,
                equipment: .volleyball,
                weather: .avoidStrongWind
            ),
        ]
    }
}
