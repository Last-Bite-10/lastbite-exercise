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

struct HistoryComponent: View {
    @Environment(ExerciseViewModel.self) private var viewModel
    @Environment(\.modelContext) private var modelContext

    @State private var selectedItem: HistoryItem?
    @State private var debugPressCount = 0

    @Query(
        filter: #Predicate<ExerciseRecord> { $0.isCompleted == true },
        sort: \ExerciseRecord.completedAt,
        order: .reverse
    ) private var completedExercises: [ExerciseRecord]

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
                .foregroundStyle(.title)
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
                            Debugging.debug(
                                "DEBUG: Exercise.loadExercises() tidak punya cukup data (butuh > 5)."
                            )
                            return
                        }

                        let exercise1 = allExercises[1]
                        let exercise2 = allExercises[5]

                        let record1 = ExerciseRecord(
                            exercise: exercise1,
                            requiredSeconds: 10 * 60,
                            usedAt: Date()
                        )
                        let record2 = ExerciseRecord(
                            exercise: exercise2,
                            requiredSeconds: 5 * 60,
                            usedAt: Date()
                        )

                        record1.isCompleted = true
                        record1.recordedSeconds = 8 * 60
                        record1.completedAt = targetDate

                        record2.isCompleted = true
                        record2.recordedSeconds = 5 * 60
                        record2.completedAt = targetDate

                        modelContext.insert(record1)
                        modelContext.insert(record2)

                        debugPrint(
                            "DEBUG: 2 record palsu berhasil dibuat untuk \(debugPressCount) hari yang lalu."
                        )
                    #endif  // DEBUG
                }

            if completedExercises.isEmpty {
                VStack {
                    Text("Start exercising to see your\nrecent histories here!")
                        .font(.headline)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.primary)
                }
                .frame(maxWidth: .infinity, minHeight: 180)
                .padding(20)
                .background(.card)
                .cornerRadius(30)
            } else {
                VStack(spacing: 12) {
                    ForEach(sortedHistoryItems) { item in
                        HistoryCardComponent(item: item) {
                            selectedItem = $0
                        }
                    }
                }
            }
        }
        .padding()
        .sheet(item: $selectedItem) { item in
            HistorySheetComponent(
                historyItem: item,
                onSetAsPlan: {
                    var newEntries: [ExerciseRecord] = []
                    for entry in item.entries {
                        let newEntry = ExerciseRecord(
                            exercise: entry.exercise!,
                            requiredSeconds: entry.requiredSeconds,
                            usedAt: Date(),
                            week: entry.week
                        )
                        newEntries.append(newEntry)
                    }

                    viewModel.modifyTodaysRecords(
                        records: newEntries
                    )

                    selectedItem = nil
                }
            )
            .presentationDetents([.fraction(0.5)])
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    HistoryComponent()
}
