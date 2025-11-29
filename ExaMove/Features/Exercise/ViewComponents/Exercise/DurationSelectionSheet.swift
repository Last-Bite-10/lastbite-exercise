//
//  DurationSelectionSheet.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

import SwiftUI

struct DurationSelectionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMinutes: Int

    let exercise: Exercise
    let existingRecord: ExerciseRecord?
    let onComplete: (ExerciseRecord?) -> Void

    let durationOptions = [5, 10, 15, 20, 25, 30, 45, 60]

    init(
        exercise: Exercise,
        existingRecord: ExerciseRecord?,
        onComplete: @escaping (ExerciseRecord?) -> Void
    ) {
        self.exercise = exercise
        self.existingRecord = existingRecord
        self.onComplete = onComplete
        _selectedMinutes = State(
            initialValue: existingRecord?.recordedSeconds.getMinutes() ?? 5
        )
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                List {
                    ForEach(durationOptions, id: \.self) { minutes in
                        HStack {
                            Text("\(minutes) minutes")
                                .font(.body)

                            Spacer()

                            if selectedMinutes == minutes {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                                    .font(.body.weight(.semibold))
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedMinutes = minutes
                        }
                    }

                    // Remove option if already selected
                    if existingRecord != nil {
                        ButtonWSound(role: .destructive) {
                            onComplete(nil)
                            dismiss()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Remove Exercise")
                                Spacer()
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Choose duration")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", systemImage: "xmark") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done", systemImage: "checkmark") {
                        let record = ExerciseRecord(
                            exercise: exercise,
                            requiredSeconds: TimeInterval(selectedMinutes * 60),
                            usedAt: Date()  // viewModel.currentlyViewedDate
                        )
                        onComplete(record)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .buttonStyle(.borderedProminent)
                    .tint(.button)
                }
            }
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    DurationSelectionSheet(
        exercise: Exercise.loadExercises().first!,
        existingRecord: nil,
        onComplete: { _ in }
    )
}
