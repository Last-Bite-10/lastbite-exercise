//
//  ExerciseSelectionCard.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

import SwiftUI

struct ExerciseSelectionCard: View {
    let exercise: Exercise
    let isExerciseSelected: (Exercise) -> Bool
    let getExerciseRecord: (Exercise) -> ExerciseRecord?
    let onSelect: (Exercise) -> Void

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
                    .frame(height: 150)
                    .overlay(
                        Image(exercise.imageName)
                            .renderingMode(.original)
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
                if let record = getExerciseRecord(exercise) {
                    VStack {
                        HStack {
                            Spacer()
                            Text(
                                "\(record.requiredSeconds.getMinutes()) min"
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
            onSelect(exercise)
        }
    }
}
