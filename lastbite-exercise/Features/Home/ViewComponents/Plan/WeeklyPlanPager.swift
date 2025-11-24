//
//  WeeklyPlanPager.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 20/11/25.
//

import SwiftData
import SwiftUI

struct WeeklyPlanPager: View {
    @Environment(RecommendationViewModel.self) private var recommendationVM
    @Environment(HomeViewModel.self) private var homeVM
    @Environment(\.modelContext) private var modelContext
    @Query private var preferences: [Preference]
    @State private var selectedRecord: ExerciseRecord?
    @State private var pagerHeight: CGFloat = .zero
    @State private var selection = 0

    // MARK: - Derived Properties
    private var preference: Preference? { preferences.first }
    private var frequency: FrequencyType { preference?.frequency ?? .oneDay }

    private var startDate: Date {
        recommendationVM.currentWeek?.startDate ?? Date()
    }

    private func dateForPage(_ index: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: index, to: startDate)
            ?? Date()
    }

    private func exercisesFor(date: Date) -> [ExerciseRecord] {
        guard let week = recommendationVM.currentWeek else { return [] }

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
        // Today's Plan Header
        WeeklyPlanHeader()

        TabView(selection: $selection) {
            ForEach(0..<frequencyTypeToInt(), id: \.self) { index in
                let dayDate = dateForPage(index)
                let dailyRecords = exercisesFor(date: dayDate)

                DailyPlanCard(
                    date: dayDate,
                    records: dailyRecords,
                    isCurrentDay: isToday(dayDate),
                    onStart: { record in selectedRecord = record }
                )
                .padding(.horizontal)
                .tag(index)
                .measureHeight { height in
                    if selection == index {
                        pagerHeight = height
                    }
                }
            }
        }
        .frame(height: pagerHeight)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .animation(.easeInOut, value: pagerHeight)
        .onAppear {
            recommendationVM.setup(modelContext: modelContext)
            if let preference = preference {
                recommendationVM.initializeWeeklyExercises(
                    preference: preference
                )
            }
        }
        .sheet(item: $selectedRecord) { record in
            RecordView(record: record, modelContext: modelContext)
        }
    }
}

#Preview {
    WeeklyPlanPager().environment(RecommendationViewModel())
}

extension View {
    func measureHeight(_ callback: @escaping (CGFloat) -> Void) -> some View {
        background(
            GeometryReader { geo in
                Color.clear
                    .onAppear { callback(geo.size.height) }
                    .onChange(of: geo.size.height) { _, new in
                        callback(new)
                    }
            }
        )
    }
}
