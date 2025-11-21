//
//  WeeklyPlanPager.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 20/11/25.
//

import SwiftData
import SwiftUI

struct WeeklyPlanPager: View {
    @Environment(RecommendationViewModel.self) private var viewModel
    @Environment(\.modelContext) private var modelContext
    @Query private var preferences: [Preference]
    @State private var selectedRecord: ExerciseRecord?

    // MARK: - Derived Properties
    private var preference: Preference? { preferences.first }
    private var frequency: FrequencyType { preference?.frequency ?? .oneDay }

    private var startDate: Date {
        viewModel.currentWeek?.startDate ?? Date()
    }

    private func dateForPage(_ index: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: index, to: startDate)
            ?? Date()
    }

    private func exercisesFor(date: Date) -> [ExerciseRecord] {
        guard let week = viewModel.currentWeek else { return [] }

        let result =
            week.records?.filter { record in
                guard let usedAt = record.usedAt else { return false }
                return Calendar.current.isDate(usedAt, inSameDayAs: date)
            } ?? []

        print("Exercises for \(date): \(result.count) records found.")
        return result
    }

    private func isToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }

    private func frequencyTypeToInt() -> Int {
        switch frequency {
        case .oneDay: return 1
        case .twoDays: return 2
        case .threeDays: return 3
        case .fourDays: return 4
        case .fiveDays: return 5
        }
    }

    // MARK: - Body
    var body: some View {
        TabView {
            ForEach(0..<frequencyTypeToInt(), id: \.self) { index in
                let dayDate = dateForPage(index)
                let dailyRecords = exercisesFor(date: dayDate)

                DailyPlanCard(
                    date: dayDate,
                    records: dailyRecords,
                    isCurrentDay: isToday(dayDate),
                    onStart: { record in
                        selectedRecord = record
                    }
                )
                .padding(.horizontal)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .sheet(item: $selectedRecord) { record in
            RecordView(record: record, modelContext: modelContext)
        }
    }
}

#Preview {
    WeeklyPlanPager().environment(RecommendationViewModel())
}
