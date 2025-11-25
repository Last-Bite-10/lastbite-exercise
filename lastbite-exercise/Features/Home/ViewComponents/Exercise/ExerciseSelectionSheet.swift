//
//  ExerciseSelectionView.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 31/10/25.
//

import SwiftUI

struct ExerciseSelectionSheet: View {
    @Environment(RecommendationViewModel.self) private var recommendationVM
    @Environment(HomeViewModel.self) private var homeVM
    @Environment(\.dismiss) var dismiss
    @State private var selectedExerciseRecords: [ExerciseRecord] = []
    @State private var currentExercise: Exercise?

    private let exercises = Exercise.loadExercises()

    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Choose your\nexercise for today")
                        .font(.title.bold())
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Recommended exercise duration: 30 mins")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                .padding(.top, 32)

                ScrollView(showsIndicators: false) {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()), GridItem(.flexible()),
                        ],
                        spacing: 24
                    ) {
                        ForEach(exercises) { exercise in
                            VStack(spacing: 12) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(.systemGray6))
                                        .frame(height: 150)
                                        .overlay(
                                            exerciseImage(for: exercise)
                                                .resizable()
                                                .scaledToFit()
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(
                                                    isExerciseSelected(exercise)
                                                        ? .title
                                                        : .clear,
                                                    lineWidth: 2
                                                )
                                        )

                                    // Show duration badge if selected
                                    if let record = getExerciseRecord(
                                        for: exercise
                                    ) {
                                        VStack {
                                            HStack {
                                                Spacer()
                                                Text(
                                                    "\(Int(record.requiredSeconds) / 60) min"
                                                )
                                                .font(.caption.bold())
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(.title)
                                                .cornerRadius(8)
                                                .padding(8)
                                            }
                                            Spacer()
                                        }
                                    }
                                }

                                Text(exercise.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            }
                            .onTapGesture {
                                currentExercise = exercise
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }

            VStack {
                Spacer()

                ButtonWSound(
                    action: {
                        recommendationVM.modifyExerciseRecords(
                            records: selectedExerciseRecords,
                            usedAt: homeVM.currentlyViewedDate
                        )
                        dismiss()
                    },
                    label: {
                        Text("Done")
                            .font(.headline)
                            .frame(width: 150)
                            .padding()
                            .background(
                                !selectedExerciseRecords.isEmpty
                                    ? .button : .disabled
                            )
                            .foregroundColor(.white)
                            .cornerRadius(30)
                            .padding(.horizontal, 40)
                    }
                )
                .disabled(selectedExerciseRecords.isEmpty)
                .edgesIgnoringSafeArea(.bottom)
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            selectedExerciseRecords = homeVM.currentlyViewedPlan
        }
        .sheet(item: $currentExercise) { exercise in
            DurationSelectionSheet(
                exercise: exercise,
                existingRecord: getExerciseRecord(for: exercise)
            ) { record in
                if let record = record {
                    addOrUpdateExerciseRecord(record)
                } else {
                    removeExerciseRecord(for: exercise)
                }
                currentExercise = nil
            }
        }
    }

    private func exerciseImage(for exercise: Exercise) -> Image {
        if let name = exercise.imageName,
            UIImage(named: name) != nil
        {
            return Image(name).renderingMode(.original)
        } else {
            return Image(systemName: "figure.strengthtraining.traditional")
        }
    }

    private func isExerciseSelected(_ exercise: Exercise) -> Bool {
        selectedExerciseRecords.contains(where: {
            $0.exercise == exercise
        })
    }

    private func getExerciseRecord(for exercise: Exercise) -> ExerciseRecord? {
        selectedExerciseRecords.first(where: { $0.exercise == exercise })
    }

    private func addOrUpdateExerciseRecord(_ record: ExerciseRecord) {
        // Remove existing record for this exercise
        selectedExerciseRecords.removeAll(where: {
            $0.exercise == record.exercise
        })
        // Add new record
        selectedExerciseRecords.append(record)
    }

    private func removeExerciseRecord(for exercise: Exercise) {
        selectedExerciseRecords.removeAll(where: {
            $0.exercise == exercise
        })
    }
}

#Preview {
    ExerciseSelectionSheet()
        .environment(RecommendationViewModel())
}
