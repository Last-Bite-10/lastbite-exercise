//
//  ExerciseSelectionSheet.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

import SwiftUI

struct ExerciseSelectionSheet: View {
    @Environment(\.dismiss) private var dismiss

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
                            ExerciseSelectionCard(
                                exercise: exercise,
                                isExerciseSelected: isExerciseSelected,
                                getExerciseRecord: getExerciseRecord,
                                onSelect: {
                                    currentExercise = $0
                                },
                            )
                        }
                    }
                }
                .padding(.horizontal)
            }

            VStack {
                Spacer()

                ButtonWSound(
                    action: {
                        // TODO: add exercise modification logic
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
    //        .environment(RecommendationViewModel())
}
