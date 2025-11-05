//
//  HistoryView.swift
//  Exa
//
//  Created by Niken Larasati on 28/10/25.
//

import SwiftData
import SwiftUI

struct HistoryItem: Identifiable {
    let id = UUID()
    let date: String
    let entries: [ExerciseRecord]
}

struct RecentHistoryView: View {
    @Environment(RecommendationViewModel.self) private var viewModel
    @Environment(\.modelContext) private var modelContext
    @State private var selectedItem: HistoryItem? = nil

    @Query(
        filter: #Predicate<ExerciseRecord> { $0.isCompleted == true },
        sort: \ExerciseRecord.completedAt,
        order: .reverse
    ) private var completedExercises: [ExerciseRecord]

    @State private var debugPressCount = 0

    var groupedHistory: [String: [ExerciseRecord]] {
        Dictionary(
            grouping: completedExercises,
            by: {
                $0.completedAt?.formatted(
                    .dateTime.weekday(.wide).day().month(.wide).year()
                ) ?? "Unknown"
            }
        )
    }

    var sortedHistoryItems: [HistoryItem] {
        let mappedItems = groupedHistory.map {
            (dateString, records) -> HistoryItem in
            return HistoryItem(date: dateString, entries: records)
        }

        let sortedItems = mappedItems.sorted {
            let date1 = $0.entries.first?.completedAt ?? Date.distantPast
            let date2 = $1.entries.first?.completedAt ?? Date.distantPast

            return date1 > date2
        }

        return sortedItems
    }

    var body: some View {
        VStack {
            Text("Recent History")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.blueTwo)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onTapGesture {
                    #if DEBUG
                        debugPressCount += 1
                        let targetDate =
                            Calendar.current.date(
                                byAdding: .day,
                                value: -debugPressCount,
                                to: Date()
                            ) ?? Date()

                        let allExercises = Exercise.loadExercises()
                        guard allExercises.count > 5 else {
                            print(
                                "DEBUG: Exercise.loadExercises() tidak punya cukup data (butuh > 5)."
                            )
                            return
                        }

                        let exercise1 = allExercises[1]
                        let exercise2 = allExercises[5]

                        let record1 = ExerciseRecord(
                            exercise: exercise1,
                            requiredMinutes: 10
                        )
                        let record2 = ExerciseRecord(
                            exercise: exercise2,
                            requiredMinutes: 5
                        )

                        record1.isCompleted = true
                        record1.recordedMinutes = 8
                        record1.completedAt = targetDate

                        record2.isCompleted = true
                        record2.recordedMinutes = 5
                        record2.completedAt = targetDate

                        modelContext.insert(record1)
                        modelContext.insert(record2)

                        print(
                            "DEBUG: 2 record palsu berhasil dibuat untuk \(debugPressCount) hari yang lalu."
                        )
                    #endif
                }

            VStack(spacing: 12) {
                ForEach(sortedHistoryItems) { item in
                    Button {
                        selectedItem = item
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            let totalRecorded = item.entries.reduce(0) {
                                $0 + $1.recordedMinutes
                            }
                            let totalRequired = item.entries.reduce(0) {
                                $0 + $1.requiredMinutes
                            }

                            Text("\(totalRecorded)/\(totalRequired) mins")
                                .font(.headline)
                                .padding(.top, 8)

                            Text(item.date)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.bottom, 8)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.cardGray)
                        .cornerRadius(30)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding()
        .sheet(item: $selectedItem) { item in
            HistoryDetailCard(historyItem: item) {

                var newEntries: [ExerciseRecord] = []
                for entry in item.entries {
                    let newEntry = ExerciseRecord(
                        exercise: entry.exercise!,
                        requiredMinutes: entry.requiredMinutes,
                        week: entry.week
                    )
                    newEntries.append(newEntry)
                }

                viewModel.modifyExerciseRecords(
                    records: newEntries
                )

                selectedItem = nil
            }
            .presentationDetents([.fraction(0.5)])
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    RecentHistoryView().environment(RecommendationViewModel())
}
