//
//  ExerciseRow.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 30/10/25.
//

import SwiftUI

struct ExerciseRow: View {
    let title: String
    let duration: Int
    let isCompleted: Bool
    var action: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 12) {
                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(Color.green)
                }
                Text(title)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(
                        isCompleted ? Color(.secondaryLabel) : Color(.label)
                    )
                    .strikethrough(isCompleted)
            }

            Spacer()

            Text("\(duration) mins")
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(Color(.secondaryLabel))
                .padding(.trailing, 16)

            if !isCompleted {
                Button(action: action) {
                    HStack(spacing: 8) {
                        Image(systemName: "play.fill")
                            .font(.headline)
                        Text("Start")
                            .font(.headline)
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .foregroundStyle(.white)
                    .background(
                        Capsule(style: .continuous)
                            .fill(
                                Color(
                                    #colorLiteral(
                                        red: 0.113,
                                        green: 0.356,
                                        blue: 0.617,
                                        alpha: 1
                                    )
                                )
                            )
                    )
                }
            } else {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark")
                        .font(.headline)
                    Text("Done")
                        .font(.headline)
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .foregroundStyle(.white)
                .background(
                    Capsule(style: .continuous)
                        .fill(Color.green)
                )
            }
        }
    }
}
