//
//  Tutorial.swift
//  lastbite-exercise
// swiftlint:disable line_length
//
//  Created by Niken Larasati on 05/11/25.
//

import Foundation

struct TutorialStep: Identifiable, Hashable {
    let id = UUID()
    let imageName: String
    let description: String
}

struct TutorialData {
    static let steps: [Int: [TutorialStep]] = [
        // Brisk walking
        1: [
            TutorialStep(
                imageName: "BriskWalking",
                description: "Walk at a pace of around 100 steps per minute. Keep your body upright, relax your shoulders, engage your core, and swing your arms naturally."
            ),
        ],
        // Push up
        2: [
            TutorialStep(
                imageName: "PushUp1",
                description: "Start in a plank with hands under shoulders and body straight. Keep core tight, balancing on your toes."
            ),
            TutorialStep(
                imageName: "PushUp2",
                description: "Lower your chest near the floor, pause, then push back up."
            )
        ],
        // Invisible jump rope
        3: [
            TutorialStep(
                imageName: "InvisibleJumpRope1",
                description: "Stand tall with feet hip-width apart, arms bent, and elbows close to your sides."
            ),
            TutorialStep(
                imageName: "InvisibleJumpRope2",
                description: "Rotate your wrists like turning a rope and hop lightly on your toes. Keep a steady rhythm."
            )
        ],
        // Vertical jump
        4: [
            TutorialStep(
                imageName: "VerticalJump1",
                description: "Stand with feet shoulder-width apart, chest up, and core tight. Bend your knees and reach your hands toward the floor."
            ),
            TutorialStep(
                imageName: "VerticalJump2",
                description: "Push through your heels and jump high, swinging your arms up. Land softly and bend your knees to absorb impact."
            )
        ],
        // Butt kicks
        5: [
            TutorialStep(
                imageName: "ButtKicks1",
                description: "Stand tall with feet hip-width apart, core tight, and arms bent at your sides."
            ),
            TutorialStep(
                imageName: "ButtKicks2",
                description: "Kick your heels toward your glutes, switching legs quickly. Keep a steady rhythm and land softly."
            )
        ],
        // Bodyweight squats
        6: [
            TutorialStep(
                imageName: "BodyweightSquats1",
                description: "Stand with feet shoulder-width apart, toes slightly out. Keep chest up, core tight, and hands behind head or forward."
            ),
            TutorialStep(
                imageName: "BodyweightSquats2",
                description: "Bend knees and push hips back like sitting on a chair. Lower down, then push through heels to stand back up."
            )
        ],
        // March in place
        7: [
            TutorialStep(
                imageName: "JogInPlace1",
                description: "Stand with feet shoulder-width apart, toes slightly out. Keep chest up, core tight, and hands behind head or forward. Lift one knee while swinging the opposite arm, then switch sides."
            ),
            TutorialStep(
                imageName: "JogInPlace2",
                description: "Keep your chest up, back straight, and breathe steadily."
            )
        ],
        // Skipping
        8: [
            TutorialStep(
                imageName: "Skipping1",
                description: "Hold the rope at hip level and swing it forward using your wrists."
            ),
            TutorialStep(
                imageName: "Skipping2",
                description: "Jump with both feet or alternate between feet. Keep jumping until the set is done."
            )
        ],
        // Plank shoulder tap
        9: [
            TutorialStep(
                imageName: "PlankShoulderTap1",
                description: "Start in a plank with wrists under shoulders and feet hip-width apart. Tap your left shoulder with your right hand."
            ),
            TutorialStep(
                imageName: "PlankShoulderTap2",
                description: "Tap your right shoulder with your left hand. Keep alternating sides."
            )
        ],
        // Dumbbell deadlift
        10: [
            TutorialStep(
                imageName: "DumbbellDeadLift1",
                description: "Stand with feet shoulder-width apart, knees slightly bent, holding dumbbells by your thighs. Hinge at the hips and keep your back flat."
            ),
            TutorialStep(
                imageName: "DumbbellDeadLift2",
                description: "Lower the dumbbells toward your shins, keeping your torso almost parallel to the floor."
            ),
            TutorialStep(
                imageName: "DumbbellDeadLift3",
                description: "Push through your heels to stand tall, keeping weights close. Squeeze your glutes at the top."
            )
        ],
        // Stair climbing
        11: [
            TutorialStep(
                imageName: "StairClimbing",
                description: "Start with a few stairs and increase gradually. Rest if you feel pain and stay consistent."
            )
        ],
        // Wall sit
        12: [
            TutorialStep(
                imageName: "WallSit",
                description: "Slide down the wall until your thighs are parallel to the floor. Keep your back flat and hold the position."
            )
        ],
        // Frog jumps
        13: [
            TutorialStep(
                imageName: "FrogJump1",
                description: "Stand with feet shoulder-width apart, chest up, shoulders back, and core tight."
            ),
            TutorialStep(
                imageName: "FrogJump2",
                description: "Bend your knees and push hips back, bringing hands to the floor between your legs."
            ),
            TutorialStep(
                imageName: "FrogJump3",
                description: "Push through your heels and jump up, arms overhead. Land softly and return to squat."
            )
        ],
        // Slow mountain climbers
        14: [
            TutorialStep(
                imageName: "SlowMountainClimbers1",
                description: "Start in a plank with hands slightly wider than shoulders and body straight."
            ),
            TutorialStep(
                imageName: "SlowMountainClimbers2",
                description: "Bring one knee toward your chest, then switch legs slowly."
            )
        ],
        // Squat jump
        15: [
            TutorialStep(
                imageName: "SquatJump1",
                description: "Stand with feet shoulder-width apart, toes slightly out. Lower into a squat as if sitting back."
            ),
            TutorialStep(
                imageName: "SquatJump2",
                description: "Push through your heels and jump up. Land softly with bent knees and return to squat."
            )
        ],
        // Jumping jacks
        16: [
            TutorialStep(
                imageName: "JumpingJacks1",
                description: "Stand with feet shoulder-width apart, toes slightly out. Lower into a squat as if sitting back."
            ),
            TutorialStep(
                imageName: "JumpingJacks2",
                description: "Push through your heels and jump up. Land softly with bent knees and return to squat."
            )
        ],
        // Jog in place
        17: [
            TutorialStep(
                imageName: "JogInPlace1",
                description: "Stand with feet shoulder-width apart, toes slightly out. Keep chest up, core tight, and hands behind head or forward. Lift one knee while swinging the opposite arm, then switch sides."
            ),
            TutorialStep(
                imageName: "JogInPlace2",
                description: "Keep your chest up, back straight, and breathe steadily."
            )
        ],
        // Bicep curl
        18: [
            TutorialStep(
                imageName: "BicepCurl1",
                description: "Stand tall with feet shoulder-width apart, holding a dumbbell in each hand by your sides."
            ),
            TutorialStep(
                imageName: "BicepCurl2",
                description: "Curl the dumbbells up while keeping elbows close. Lower them slowly back down and repeat."
            )
        ],
        // Dumbbell thruster
        19: [
            TutorialStep(
                imageName: "DumbbellThruster1",
                description: "Stand with feet shoulder-width apart, holding dumbbells at shoulder level. Squat until your thighs are parallel to the floor."
            ),
            TutorialStep(
                imageName: "DumbbellThruster2",
                description: "Stand up and press the dumbbells overhead."
            ),
            TutorialStep(
                imageName: "DumbbellThruster3",
                description: "Lower the dumbbells back to your shoulders and repeat."
            )
        ],
        // Lunge
        20: [
            TutorialStep(
                imageName: "Lunge1",
                description: "Stand tall with feet hip-width apart, back straight, shoulders back, and core tight."
            ),
            TutorialStep(
                imageName: "Lunge2",
                description: "Step forward, bend both knees until the back knee is near the floor. Push back up and switch legs."
            )
        ],
        // Badminton
        21: [
            TutorialStep(
                imageName: "Badminton",
                description: "Play badminton by moving actively, hitting the shuttle with control, and keeping a steady rhythm throughout the game"
            )
        ],
        // Jogging
        22: [
            TutorialStep(
                imageName: "Jogging",
                description: "Jog at a comfortable pace while keeping your posture upright, breathing steadily, and maintaining consistency to build endurance and strength"
            )
        ],
        // Cycling
        23: [
            TutorialStep(
                imageName: "Cycling",
                description: "Ride at a steady rhythm, keep your core engaged, and focus on smooth pedaling to strengthen your legs and improve cardiovascular health"
            )
        ],
        // Tennis
        24: [
            TutorialStep(
                imageName: "Tennis",
                description: "Move quickly across the court, control your swings, and stay alert to build coordination, agility, and overall body strength"
            )
        ],
        // Volleyball
        25: [
            TutorialStep(
                imageName: "Volleyball",
                description: "Stay light on your feet, communicate with teammates, and react fast to improve teamwork, coordination, and upper body power"
            )
        ]
    ]
}
