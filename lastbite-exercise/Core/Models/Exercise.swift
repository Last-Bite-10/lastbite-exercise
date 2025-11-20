//
//  Exercise.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 30/10/25.
//

import Foundation

struct Exercise: Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let imageName: String?
    let location: LocationType
    let needsTutorial: Bool
    let equipment: EquipmentType
    let weather: WeatherType

    public static func loadExercises() -> [Exercise] {
        return [
            Exercise(
                id: UUID(),
                name: "Brisk walking",
                imageName: "BriskWalking",
                location: .outdoor,
                needsTutorial: false,
                equipment: .none,
                weather: .clear
            ),
            Exercise(
                id: UUID(),
                name: "Push up",
                imageName: "PushUp1",
                location: .indoor,
                needsTutorial: true,
                equipment: .none,
                weather: .clear
            ),
            Exercise(
                id: UUID(),
                name: "Invisible jump rope",
                imageName: "InvisibleJumpRope1",
                location: .indoor,
                needsTutorial: true,
                equipment: .none,
                weather: .clear
            ),
            Exercise(
                id: UUID(),
                name: "Vertical jump",
                imageName: "VerticalJump1",
                location: .indoor,
                needsTutorial: true,
                equipment: .none,
                weather: .notAffected
            ),
            Exercise(
                id: UUID(),
                name: "Butt kicks",
                imageName: "ButtKicks1",
                location: .both,
                needsTutorial: true,
                equipment: .none,
                weather: .clear
            ),
            Exercise(
                id: UUID(),
                name: "Bodyweight squats",
                imageName: "BodyweightSquats1",
                location: .indoor,
                needsTutorial: true,
                equipment: .none,
                weather: .notAffected
            ),
            Exercise(
                id: UUID(),
                name: "March in place",
                imageName: "JogInPlace1",
                location: .indoor,
                needsTutorial: true,
                equipment: .none,
                weather: .notAffected
            ),
            Exercise(
                id: UUID(),
                name: "Skipping",
                imageName: "Skipping1",
                location: .both,
                needsTutorial: true,
                equipment: .jumpRope,
                weather: .clear
            ),
            Exercise(
                id: UUID(),
                name: "Plank shoulder tap",
                imageName: "PlankShoulderTap1",
                location: .indoor,
                needsTutorial: true,
                equipment: .matress,
                weather: .notAffected
            ),
            Exercise(
                id: UUID(),
                name: "Dumbbell deadlift",
                imageName: "DumbbellDeadLift1",
                location: .indoor,
                needsTutorial: true,
                equipment: .dumbbell,
                weather: .notAffected
            ),
            Exercise(
                id: UUID(),
                name: "Stair climbing",
                imageName: "StairClimbing",
                location: .indoor,
                needsTutorial: false,
                equipment: .stairs,
                weather: .notAffected
            ),
            Exercise(
                id: UUID(),
                name: "Wall sit",
                imageName: "WallSit",
                location: .indoor,
                needsTutorial: true,
                equipment: .none,
                weather: .notAffected
            ),
            Exercise(
                id: UUID(),
                name: "Frog jumps",
                imageName: "FrogJump1",
                location: .indoor,
                needsTutorial: true,
                equipment: .none,
                weather: .notAffected
            ),
            Exercise(
                id: UUID(),
                name: "Mountain climbers",
                imageName: "SlowMountainClimbers1",
                location: .indoor,
                needsTutorial: true,
                equipment: .matress,
                weather: .notAffected
            ),
            Exercise(
                id: UUID(),
                name: "Squat jump",
                imageName: "SquatJump1",
                location: .indoor,
                needsTutorial: true,
                equipment: .none,
                weather: .notAffected
            ),
            Exercise(
                id: UUID(),
                name: "Jumping jacks",
                imageName: "JumpingJacks1",
                location: .both,
                needsTutorial: false,
                equipment: .none,
                weather: .clear
            ),
            Exercise(
                id: UUID(),
                name: "Jog in place",
                imageName: "JogInPlace1",
                location: .indoor,
                needsTutorial: false,
                equipment: .none,
                weather: .notAffected
            ),
            Exercise(
                id: UUID(),
                name: "Bicep curl",
                imageName: "BicepCurl1",
                location: .indoor,
                needsTutorial: true,
                equipment: .dumbbell,
                weather: .notAffected
            ),
            Exercise(
                id: UUID(),
                name: "Dumbbell thruster",
                imageName: "DumbbellThruster1",
                location: .indoor,
                needsTutorial: true,
                equipment: .dumbbell,
                weather: .notAffected
            ),
            Exercise(
                id: UUID(),
                name: "Lunge",
                imageName: "Lunge1",
                location: .both,
                needsTutorial: true,
                equipment: .none,
                weather: .clear
            ),
            Exercise(
                id: UUID(),
                name: "Badminton",
                imageName: "Badminton",
                location: .outdoor,
                needsTutorial: false,
                equipment: .badminton,
                weather: .noStrongWind
            ),
            Exercise(
                id: UUID(),
                name: "Jogging",
                imageName: "Jogging1",
                location: .outdoor,
                needsTutorial: false,
                equipment: .none,
                weather: .clear
            ),
            Exercise(
                id: UUID(),
                name: "Cycling",
                imageName: "Cycling",
                location: .outdoor,
                needsTutorial: false,
                equipment: .bike,
                weather: .clear
            ),
            Exercise(
                id: UUID(),
                name: "Tennis",
                imageName: "Tennis",
                location: .outdoor,
                needsTutorial: false,
                equipment: .tennisRacket,
                weather: .notAffected
            ),
            Exercise(
                id: UUID(),
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
