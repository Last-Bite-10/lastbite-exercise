//
//  TodayPlanView.swift
//  lastbite-exercise
//
//  Created by Niken Larasati on 23/10/25.
//

import SwiftUI

struct Exercise: Identifiable {
    let id = UUID()
    let name: String
    let duration: Int
    let icon: String
}

struct TodaysPlanView: View {
    let exercises: [Exercise]
    let completedMinutes: Int
    let totalMinutes: Int
    let date: Date
    let onStartExercise: (Exercise) -> Void
    let onModify: () -> Void

    var progress: Double {
        Double(completedMinutes) / Double(totalMinutes)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Today's Plan")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))

            VStack(alignment: .leading, spacing: 16) {
                // Header dengan tanggal dan progress
                HStack {
                    Image(systemName: "figure.walk")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)

                    VStack(alignment: .leading, spacing: 8) {
                        Text(
                            date,
                            format: .dateTime.weekday().day().month().year()
                        )
                        .font(.headline)

                        HStack {
                            ProgressView(value: progress)
                                .tint(.blue)
                                .frame(width: 100)

                            Text("\(Int(progress * 100))%")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Text("\(completedMinutes)/\(totalMinutes) mins")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()
                }

                // Daftar exercise
                ForEach(exercises) { exercise in
                    HStack {
                        HStack {
                            Text(exercise.name)
                                .font(.body)

                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                                .font(.caption)
                        }

                        Spacer()

                        Text("\(exercise.duration) mins")
                            .foregroundColor(.secondary)

                        Button(
                            action: {
                                onStartExercise(exercise)
                            },
                            label: {
                                HStack {
                                    Image(systemName: "play.fill")
                                    Text("Start")
                                }
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .cornerRadius(20)
                            }
                        )
                    }
                    .padding(.vertical, 4)
                }

                // Modify button
                Button(action: onModify) {
                    Text("Modify")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}
