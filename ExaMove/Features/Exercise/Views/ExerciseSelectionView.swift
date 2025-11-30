//
//  ExerciseSelectionSheet.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

import SwiftData
import SwiftUI

struct ExerciseSelectionView: View {
    @Environment(ExerciseViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss

    @State private var selectedExerciseRecords: [ExerciseRecord] = []
    @State private var currentExercise: Exercise?

    private var exercises: [Exercise] { Exercise.loadExercises() }

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

    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Choose your\nexercise for today")
                        .font(.title.bold())
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Recommended exercise duration: 30 mins")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
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
                        viewModel.modifyTodaysRecords(
                            records: selectedExerciseRecords,
                            usedAt: Date()
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
                            .foregroundStyle(.white)
                            .cornerRadius(30)
                            .padding(.horizontal, 40)
                    }
                )
                .disabled(selectedExerciseRecords.isEmpty)
                .edgesIgnoringSafeArea(.bottom)
                .padding(.bottom, 20)
            }
        }
        .task {
            if selectedExerciseRecords.isEmpty {
                selectedExerciseRecords = viewModel.currentSelectedDateRecords
            }
        }
        .sheet(item: $currentExercise) { exercise in
            DurationSelectionSheet(
                exercise: exercise,
                existingRecord: getExerciseRecord(for: exercise),
                usedAtDate: viewModel.currentSelectedDate ?? Date()
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
}

#Preview {
    ExerciseSelectionView().environment(ExerciseViewModel())
}
