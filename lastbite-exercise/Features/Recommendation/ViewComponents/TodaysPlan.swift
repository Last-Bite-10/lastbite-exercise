//
//  TodaysPlan.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 23/10/25.
//

import SwiftData
import SwiftUI

struct TodaysPlan: View {
    @State private var tfModel: TFIDFRecommenderViewModel
    @State private var weekNumber: Int = 1
    @State private var currentRecords: [Record]
    @Query private var records: [Record]
    @Query private var preference: [Preference]
    @Environment(\.modelContext) private var modelContext

    let progress = 0.2
    let completedMinutes = 2
    let totalMinutes = 10

    private let date: Date = .now

    init() {
        _tfModel = State(
            initialValue: TFIDFRecommenderViewModel(preference.first!)
        )
        if records.isEmpty {
            let firstRecord = Record(
                date: date,
                weekNumber: weekNumber,
                chosenFrequency: preference.first!.frequency,
                exercise: tfModel.recommendedExercises.first!
            )
            let secondRecord = Record(
                date: date,
                weekNumber: weekNumber,
                chosenFrequency: preference.first!.frequency,
                exercise: tfModel.recommendedExercises[1]
            )
            _currentRecords = State(initialValue: [firstRecord, secondRecord])
            modelContext.insert(firstRecord)
            modelContext.insert(secondRecord)
        } else {
            _currentRecords = State(
                initialValue: records.suffix(2)
            )
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header
            progressSection
            Divider().padding(.horizontal, 8)
            VStack(spacing: 20) {
                ForEach(currentRecords) { record in
                    ExerciseRow(
                        title: record.exercise.name,
                        duration: Int(record.targetTime),
                        action: {}
                    )
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
    }

    private var header: some View {
        HStack(alignment: .top) {
            // Placeholder illustration circle to mimic character
            ZStack {
                Circle().fill(Color.blue.opacity(0.12))
                Image(systemName: "figure.cooldown")
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundStyle(Color.blue)
            }
            .frame(width: 72, height: 72)

            VStack(alignment: .leading, spacing: 8) {
                Text(
                    date.formatted(
                        .dateTime.weekday(.wide).day().month(.wide).year()
                    )
                )
                .font(.system(.title2, weight: .bold))
                .foregroundStyle(Color(.label))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
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
}

struct ExerciseRow: View {
    let title: String
    let duration: Int
    var action: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Color(.label))
            Spacer()
            Text("\(duration) mins")
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(Color(.secondaryLabel))
                .padding(.trailing, 16)
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
        }
    }
}

struct ProgressBar: View {
    var value: Double  // 0...1

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Color.white).shadow(
                    color: Color.black.opacity(0.02),
                    radius: 1,
                    x: 0,
                    y: 1
                )
                Capsule().fill(
                    Color(
                        #colorLiteral(
                            red: 0.113,
                            green: 0.356,
                            blue: 0.617,
                            alpha: 1
                        )
                    )
                ).frame(width: max(12, geo.size.width * value))
            }
        }
        .frame(height: 12)
        .padding(.trailing, 12)
        .background(
            Capsule().stroke(Color.white.opacity(0.7), lineWidth: 6)
        )
    }
}

#Preview {
    TodaysPlan()
}
