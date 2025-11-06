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
                imageName: "Brisk Walking",
                description: "..."
            ),
        ],
        // Push up
        2: [
            TutorialStep(
                imageName: "Push Up 1",
                description: "Start in a plank with hands under shoulders and body straight. Keep core tight, balancing on your toes."
            ),
            TutorialStep(
                imageName: "Push Up 2",
                description: "Lower your chest near the floor, pause, then push back up."
            )
        ],
        // Invisible jump rope
        3: [
            TutorialStep(
                imageName: "Invisible Jump Rope 1",
                description: "Stand tall with feet hip-width apart, arms bent, and elbows close to your sides."
            ),
            TutorialStep(
                imageName: "Invisible Jump Rope 2",
                description: "Rotate your wrists like turning a rope and hop lightly on your toes. Keep a steady rhythm."
            )
        ],
        // Vertical jump
        4: [
            TutorialStep(
                imageName: "Invisible Jump Rope 1",
                description: "Stand tall with feet hip-width apart, arms bent, and elbows close to your sides."
            )
        ],
        // Butt kicks
        5: [
            TutorialStep(
                imageName: "Butt Kicks 1",
                description: "Stand tall with feet hip-width apart, core tight, and arms bent at your sides."
            ),
            TutorialStep(
                imageName: "Butt Kicks 2",
                description: "Kick your heels toward your glutes, switching legs quickly. Keep a steady rhythm and land softly."
            )
        ],
        // Bodyweight squats
        6: [
            TutorialStep(
                imageName: "Bodyweight Squats 1",
                description: "Stand with feet shoulder-width apart, toes slightly out. Keep chest up, core tight, and hands behind head or forward."
            ),
            TutorialStep(
                imageName: "Bodyweight Squats 2",
                description: "Bend knees and push hips back like sitting on a chair. Lower down, then push through heels to stand back up."
            )
        ],
        // March in place
        7: [
            TutorialStep(
                imageName: "Jog in Place 1",
                description: "Stand with feet shoulder-width apart, toes slightly out. Keep chest up, core tight, and hands behind head or forward. Lift one knee while swinging the opposite arm, then switch sides."
            ),
            TutorialStep(
                imageName: "Jog in Place 2",
                description: "Keep your chest up, back straight, and breathe steadily."
            )
        ],
        // Skipping
        8: [
            TutorialStep(
                imageName: "Skipping 1",
                description: "Hold the rope at hip level and swing it forward using your wrists."
            ),
            TutorialStep(
                imageName: "Skipping 2",
                description: "Jump with both feet or alternate between feet. Keep jumping until the set is done."
            )
        ],
        // Plank shoulder tap
        9: [
            TutorialStep(
                imageName: "Plank Shoulder Tap 1",
                description: "Start in a plank with wrists under shoulders and feet hip-width apart. Tap your left shoulder with your right hand."
            ),
            TutorialStep(
                imageName: "Plank Shoulder Tap 2",
                description: "Tap your right shoulder with your left hand. Keep alternating sides."
            )
        ],
        // Dumbbell deadlift
        10: [
            TutorialStep(
                imageName: "Dumbbell Dead Lift 1",
                description: "Stand with feet shoulder-width apart, knees slightly bent, holding dumbbells by your thighs. Hinge at the hips and keep your back flat."
            ),
            TutorialStep(
                imageName: "Dumbbell Dead Lift 2",
                description: "Lower the dumbbells toward your shins, keeping your torso almost parallel to the floor."
            ),
            TutorialStep(
                imageName: "Dumbbell Dead Lift 3",
                description: "Push through your heels to stand tall, keeping weights close. Squeeze your glutes at the top."
            )
        ],
        // Stair climbing
        11: [
            TutorialStep(
                imageName: "Dumbbell Dead Lift 3",
                description: "..."
            )
        ],
        // Wall sit
        12: [
            TutorialStep(
                imageName: "Wall Sit",
                description: "Slide down the wall until your thighs are parallel to the floor. Keep your back flat and hold the position."
            )
        ],
        // Frog jumps
        13: [
            TutorialStep(
                imageName: "Frog Jump 1",
                description: "Stand with feet shoulder-width apart, chest up, shoulders back, and core tight."
            ),
            TutorialStep(
                imageName: "Frog Jump 2",
                description: "Bend your knees and push hips back, bringing hands to the floor between your legs."
            ),
            TutorialStep(
                imageName: "Frog Jump 3",
                description: "Push through your heels and jump up, arms overhead. Land softly and return to squat."
            )
        ],
        // Slow mountain climbers
        14: [
            TutorialStep(
                imageName: "Slow Mountain Climbers 1",
                description: "Start in a plank with hands slightly wider than shoulders and body straight."
            ),
            TutorialStep(
                imageName: "Slow Mountain Climbers 2",
                description: "Bring one knee toward your chest, then switch legs slowly."
            )
        ],
        // Squat jump
        15: [
            TutorialStep(
                imageName: "Squat Jump 1",
                description: "Stand with feet shoulder-width apart, toes slightly out. Lower into a squat as if sitting back."
            ),
            TutorialStep(
                imageName: "Squat Jump 2",
                description: "Push through your heels and jump up. Land softly with bent knees and return to squat."
            )
        ],
        // Jumping jacks
        16: [
            TutorialStep(
                imageName: "Squat Jump 1",
                description: "Stand with feet shoulder-width apart, toes slightly out. Lower into a squat as if sitting back."
            ),
            TutorialStep(
                imageName: "Squat Jump 2",
                description: "Push through your heels and jump up. Land softly with bent knees and return to squat."
            )
        ],
        // Jog in place
        17: [
            TutorialStep(
                imageName: "Jog in Place",
                description: "..."
            ),
        ],
        // Bicep curl
        18: [
            TutorialStep(
                imageName: "Bicep Curl 1",
                description: "Stand tall with feet shoulder-width apart, holding a dumbbell in each hand by your sides."
            ),
            TutorialStep(
                imageName: "Bicep Curl 2",
                description: "Curl the dumbbells up while keeping elbows close. Lower them slowly back down and repeat."
            )
        ],
        // Dumbbell thruster
        19: [
            TutorialStep(
                imageName: "Dumbbell Thruster 1",
                description: "Stand with feet shoulder-width apart, holding dumbbells at shoulder level. Squat until your thighs are parallel to the floor."
            ),
            TutorialStep(
                imageName: "Dumbbell Thruster 2",
                description: "Stand up and press the dumbbells overhead."
            ),
            TutorialStep(
                imageName: "Dumbbell Thruster 3",
                description: "Lower the dumbbells back to your shoulders and repeat."
            )
        ],
        // Lunge
        20: [
            TutorialStep(
                imageName: "Lunge 1",
                description: "Stand tall with feet hip-width apart, back straight, shoulders back, and core tight."
            ),
            TutorialStep(
                imageName: "Lunge 2",
                description: "Step forward, bend both knees until the back knee is near the floor. Push back up and switch legs."
            )
        ],
        // Badminton
        21: [
            TutorialStep(
                imageName: "Badminton",
                description: "..."
            )
        ],
        // Jogging
        22: [
            TutorialStep(
                imageName: "Jogging",
                description: "..."
            )
        ],
        // Cycling
        23: [
            TutorialStep(
                imageName: "Cycling",
                description: "..."
            )
        ],
        // Tennis
        24: [
            TutorialStep(
                imageName: "Tennis",
                description: "..."
            )
        ],
        // Volleyball
        25: [
            TutorialStep(
                imageName: "Volleyball",
                description: "..."
            )
        ]
    ]
}
