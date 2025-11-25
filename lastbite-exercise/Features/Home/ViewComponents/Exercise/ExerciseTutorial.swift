//
//  ExerciseTutorial.swift
//  lastbite-exercise
//
//  Created by Niken Larasati on 05/11/25.
//

import SwiftUI

struct ExerciseTutorial: View {
    let exercise: Exercise

    @State private var steps: [TutorialStep] = []

    @State private var currentStepIndex = 0

    var body: some View {
        VStack(spacing: 20) {

            Text(exercise.name)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 50)

            if !steps.isEmpty {

                TabView(selection: $currentStepIndex) {
                    ForEach(steps.indices, id: \.self) { index in
                        Image(steps[index].imageName)
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 300)

                HStack(spacing: 8) {
                    ForEach(steps.indices, id: \.self) { index in
                        Circle()
                            .fill(
                                index == currentStepIndex
                                    ? .blue : .gray.opacity(0.5)
                            )
                            .frame(width: 8, height: 8)
                    }
                }

                Text(steps[currentStepIndex].description)
                    .font(.body)
                    .padding()
                    .frame(minHeight: 100)
                    .frame(width: 350)
                    .multilineTextAlignment(.center)
                    .animation(.easeInOut, value: currentStepIndex)

            } else {
                Image(exercise.imageName ?? "placeholder-image")  //
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                Text("No tutorial steps available for this exercise.")
                    .font(.body)
                    .padding()
            }

            Spacer()
        }
        .onAppear {
            loadTutorialData()
        }
    }

    private func loadTutorialData() {
        if let tutorialSteps = TutorialData.steps[exercise.id] {
            self.steps = tutorialSteps
        } else if exercise.needsTutorial, let mainImage = exercise.imageName {
            self.steps = [
                TutorialStep(
                    imageName: mainImage,
                    description: "Follow the visual guide for \(exercise.name)."
                )
            ]
        }
    }
}

#Preview {

    let mockExercise = Exercise.loadExercises().first(where: { $0.id == 2 })

    return ExerciseTutorial(exercise: mockExercise!)
}
