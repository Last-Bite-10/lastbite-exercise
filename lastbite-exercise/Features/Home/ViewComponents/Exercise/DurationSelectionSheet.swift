//
//  DurationSelectionSheet.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 03/11/25.
//

import SwiftUI

// MARK: - Duration Selection Sheet
struct DurationSelectionSheet: View {
    let exercise: Exercise
    let existingRecord: ExerciseRecord?
    let onComplete: (ExerciseRecord?) -> Void

    @State private var selectedMinutes: Int
    @Environment(\.dismiss) var dismiss

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
            initialValue: existingRecord?.recordedMinutes ?? 5
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
                        Button(role: .destructive) {
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
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        let record = ExerciseRecord(
                            exercise: exercise,
                            requiredMinutes: selectedMinutes
                        )
                        onComplete(record)
                        dismiss()
                    }
                    .fontWeight(.semibold)
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
