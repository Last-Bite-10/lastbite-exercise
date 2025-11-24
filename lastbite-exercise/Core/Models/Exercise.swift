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
                imageName: "BriskWalking",
                location: .outdoor,
                needsTutorial: false,
                equipment: .none,
                weather: .clear
            ),
            Exercise(
                id: 2,
                name: "Push up",
                imageName: "PushUp1",
                location: .indoor,
                needsTutorial: true,
                equipment: .none,
                weather: .clear
            ),
            Exercise(
                id: 3,
                name: "Invisible jump rope",
                imageName: "InvisibleJumpRope1",
                location: .indoor,
                needsTutorial: true,
                equipment: .none,
                weather: .clear
            ),
            Exercise(
                id: 4,
                name: "Vertical jump",
                imageName: "VerticalJump1",
                location: .indoor,
                needsTutorial: true,
                equipment: .none,
                weather: .notAffected
            ),
            Exercise(
                id: 5,
                name: "Butt kicks",
                imageName: "ButtKicks1",
                location: .both,
                needsTutorial: true,
                equipment: .none,
                weather: .clear
            ),
            Exercise(
                id: 6,
                name: "Bodyweight squats",
                imageName: "BodyweightSquats1",
                location: .indoor,
                needsTutorial: true,
                equipment: .none,
                weather: .notAffected
            ),
            Exercise(
                id: 7,
                name: "March in place",
                imageName: "JogInPlace1",
                location: .indoor,
                needsTutorial: true,
                equipment: .none,
                weather: .notAffected
            ),
            Exercise(
                id: 8,
                name: "Skipping",
                imageName: "Skipping1",
                location: .both,
                needsTutorial: true,
                equipment: .jumpRope,
                weather: .clear
            ),
            Exercise(
                id: 9,
                name: "Plank shoulder tap",
                imageName: "PlankShoulderTap1",
                location: .indoor,
                needsTutorial: true,
                equipment: .matress,
                weather: .notAffected
            ),
            Exercise(
                id: 10,
                name: "Dumbbell deadlift",
                imageName: "DumbbellDeadLift1",
                location: .indoor,
                needsTutorial: true,
                equipment: .dumbbell,
                weather: .notAffected
            ),
            Exercise(
                id: 11,
                name: "Stair climbing",
                imageName: "StairClimbing",
                location: .indoor,
                needsTutorial: false,
                equipment: .stairs,
                weather: .notAffected
            ),
            Exercise(
                id: 12,
                name: "Wall sit",
                imageName: "WallSit",
                location: .indoor,
                needsTutorial: true,
                equipment: .none,
                weather: .notAffected
            ),
            Exercise(
                id: 13,
                name: "Frog jumps",
                imageName: "FrogJump1",
                location: .indoor,
                needsTutorial: true,
                equipment: .none,
                weather: .notAffected
            ),
            Exercise(
                id: 14,
                name: "Mountain climbers",
                imageName: "SlowMountainClimbers1",
                location: .indoor,
                needsTutorial: true,
                equipment: .matress,
                weather: .notAffected
            ),
            Exercise(
                id: 15,
                name: "Squat jump",
                imageName: "SquatJump1",
                location: .indoor,
                needsTutorial: true,
                equipment: .none,
                weather: .notAffected
            ),
            Exercise(
                id: 16,
                name: "Jumping jacks",
                imageName: "JumpingJacks1",
                location: .both,
                needsTutorial: false,
                equipment: .none,
                weather: .clear
            ),
            Exercise(
                id: 17,
                name: "Jog in place",
                imageName: "JogInPlace1",
                location: .indoor,
                needsTutorial: false,
                equipment: .none,
                weather: .notAffected
            ),
            Exercise(
                id: 18,
                name: "Bicep curl",
                imageName: "BicepCurl1",
                location: .indoor,
                needsTutorial: true,
                equipment: .dumbbell,
                weather: .notAffected
            ),
            Exercise(
                id: 19,
                name: "Dumbbell thruster",
                imageName: "DumbbellThruster1",
                location: .indoor,
                needsTutorial: true,
                equipment: .dumbbell,
                weather: .notAffected
            ),
            Exercise(
                id: 20,
                name: "Lunge",
                imageName: "Lunge1",
                location: .both,
                needsTutorial: true,
                equipment: .none,
                weather: .clear
            ),
            Exercise(
                id: 21,
                name: "Badminton",
                imageName: "Badminton",
                location: .outdoor,
                needsTutorial: false,
                equipment: .badminton,
                weather: .noStrongWind
            ),
            Exercise(
                id: 22,
                name: "Jogging",
                imageName: "Jogging",
                location: .outdoor,
                needsTutorial: false,
                equipment: .none,
                weather: .clear
            ),
            Exercise(
                id: 23,
                name: "Cycling",
                imageName: "Cycling",
                location: .outdoor,
                needsTutorial: false,
                equipment: .bike,
                weather: .clear
            ),
            Exercise(
                id: 24,
                name: "Tennis",
                imageName: "Tennis",
                location: .outdoor,
                needsTutorial: false,
                equipment: .tennisRacket,
                weather: .notAffected
            ),
            Exercise(
                id: 25,
                name: "Volleyball",
                imageName: "Volleyball",
                location: .outdoor,
                needsTutorial: false,
                equipment: .volleyball,
                weather: .avoidStrongWind
            ),
        ]
    }
}
