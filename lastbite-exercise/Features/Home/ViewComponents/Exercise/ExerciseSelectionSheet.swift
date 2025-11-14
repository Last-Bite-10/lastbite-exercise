//
//  ExerciseSelectionView.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 31/10/25.
//

import SwiftUI

struct ExerciseSelectionSheet: View {
    @Environment(RecommendationViewModel.self) private var viewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedExerciseRecords: [ExerciseRecord] = []
    @State private var currentExercise: Exercise?

    private let exercises = Exercise.loadExercises()

    var body: some View {
        VStack(spacing: 24) {
            // MARK: - Header
            VStack(spacing: 8) {
                Text("Choose your\nexercise for today")
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)

                Text("Recommended exercise duration: 30 mins")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 32)

            // MARK: - Grid
            ScrollView(showsIndicators: false) {
                LazyVGrid(
                    columns: [GridItem(.flexible()), GridItem(.flexible())],
                    spacing: 24
                ) {
                    ForEach(exercises) { exercise in
                        VStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.systemGray6))
                                    .frame(height: 120)
                                    .overlay(
                                        exerciseImage(for: exercise)
                                        .resizable()
                                        .scaledToFit()
//                                        .frame(width: 60, height: 60)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(
                                                isExerciseSelected(exercise)
                                                    ? Color.blue : Color.clear,
                                                lineWidth: 2
                                            )
                                    )

                                // Show duration badge if selected
                                if let record = getExerciseRecord(for: exercise)
                                {
                                    VStack {
                                        HStack {
                                            Spacer()
                                            Text(
                                                "\(record.requiredMinutes) min"
                                            )
                                            .font(.caption.bold())
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.blue)
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

            // MARK: - Done Button
            Button(
                action: {
                    // Pass selected records to view model
                    viewModel.modifyExerciseRecords(
                        records: selectedExerciseRecords
                    )
                    dismiss()
                },
                label: {
                    Text("Done")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            !selectedExerciseRecords.isEmpty
                                ? Color.blue : Color.gray.opacity(0.4)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .padding(.horizontal, 40)
                }
            )
            .disabled(selectedExerciseRecords.isEmpty)

            Spacer()
        }
//        .presentationDetents([.medium, .large])
        .padding(.bottom, 20)
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
                // Dismiss by clearing the item (optional; SwiftUI will dismiss automatically when you set it to nil)
                currentExercise = nil
            }
        }
    }
    
    private func exerciseImage(for exercise: Exercise) -> Image {
        if let name = exercise.imageName,
           UIImage(named: name) != nil {
            return Image(name).renderingMode(.original)
        } else {
            return Image(systemName: "figure.strengthtraining.traditional")
        }
    }

    // MARK: - Helper Methods
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

// MARK: - Preview
#Preview {
    ExerciseSelectionSheet()
        .environment(RecommendationViewModel())
}
