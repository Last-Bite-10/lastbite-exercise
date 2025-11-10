//
//  TodaysPlan.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 30/10/25.
//

import SwiftData
import SwiftUI

struct TodaysPlan: View {
    @Environment(RecommendationViewModel.self) private var viewModel
    @Environment(\.modelContext) private var modelContext

    @Query private var preferences: [Preference]
    @Query private var weeklies: [Weekly]

    @State private var showRecording = false
    @State private var selectedRecord: ExerciseRecord?

    @StateObject private var healthManager = HealthKitManager.shared

    private let date: Date = .now

    // Computed properties for progress tracking
    private var currentRecords: [ExerciseRecord] {
        viewModel.currentWeek?.records ?? []
    }

    private var completedMinutes: Int {
        currentRecords.reduce(0) { $0 + Int($1.recordedMinutes) }
    }

    private var totalMinutes: Int {
        currentRecords.reduce(0) { $0 + Int($1.requiredMinutes) }
    }

    private var progress: Double {
        guard totalMinutes > 0 else { return 0 }
        return Double(completedMinutes) / Double(totalMinutes)
    }

    var body: some View {
        VStack(alignment: .leading) {
            header
            progressSection
            Divider().padding(.horizontal, 8)

            if currentRecords.isEmpty {
                emptyStateView
            } else {
                VStack(spacing: 20) {
                    ForEach(currentRecords) { record in
                        ExerciseRow(
                            title: record.exercise?.name ?? "Unnamed Exercise",
                            duration: Int(record.requiredMinutes),
                            isCompleted: record.isCompleted,
                            action: {
                                selectedRecord = record
                                showRecording = true
                            },
                            exercise: record.exercise!
                        )
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .strokeBorder(Color(.systemGray4).opacity(0.4), lineWidth: 0.5)
        )
        .padding()
        .sheet(isPresented: $showRecording) {
            if selectedRecord != nil {
                RecordView(record: selectedRecord!, modelContext: modelContext)
            }
        }
        .onAppear {
            viewModel.setup(modelContext: modelContext)
            if let preference = preferences.first {
                viewModel.initializeWeeklyExercises(preference: preference)
            }
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            ZStack {
                Circle().fill(Color.blue.opacity(0.12))
                Image(systemName: "figure.cooldown")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(Color.blue)
            }
            .frame(width: 60, height: 60)

            VStack(alignment: .leading, spacing: 8) {
                Text(
                    date.formatted(
                        .dateTime.weekday(.wide).day().month(.wide).year()
                    )
                )
                .font(.system(.headline, weight: .bold))
                .foregroundStyle(Color(.label))

                if let week = viewModel.currentWeek {
                    Text("Week \(week.weekNumber)")
                        .font(.subheadline)
                        .foregroundStyle(Color(.secondaryLabel))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 10)
        }
    }

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                ProgressBar(value: progress)
                    .frame(height: 12)
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color(.label))
                    Text("\(completedMinutes)/\(totalMinutes) mins")
                        .font(.subheadline)
                        .foregroundStyle(Color(.secondaryLabel))
                }
                .frame(width: 90, alignment: .trailing)
            }
        }
        .padding(.top, 4)
    }

    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "figure.run.circle")
                .font(.system(size: 48))
                .foregroundStyle(Color(.secondaryLabel))
            Text("No exercises planned yet")
                .font(.headline)
                .foregroundStyle(Color(.secondaryLabel))
            Text("Complete the questionnaire to get started")
                .font(.subheadline)
                .foregroundStyle(Color(.tertiaryLabel))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
    }
}
