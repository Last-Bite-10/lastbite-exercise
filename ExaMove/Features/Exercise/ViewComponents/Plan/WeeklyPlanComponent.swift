//
//  WeeklyPlanPager.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

//
//  WeeklyPlanPager.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 20/11/25.
//

import SwiftData
import SwiftUI

struct WeeklyPlanComponent: View {
    @Environment(ExerciseViewModel.self) private var viewModel
    @Environment(\.modelContext) private var modelContext

    @Query private var preferences: [Preference]

    @State private var selectedRecord: ExerciseRecord?
    @State private var selection = 0

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
                return Calendar.current.isDate(record.usedAt, inSameDayAs: date)
            } ?? []

        Debugging.debug("Exercises for \(date): \(result.count) records found.")
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
        VStack {
            HStack {
                Text("This Week's Plan")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.title)

                Spacer()

                ButtonWSound(
                    action: {
                        viewModel.showPlanModifySheet = true
                    },
                    label: {
                        HStack(spacing: 4) {
                            Image(systemName: "pencil")
                                .font(.system(size: 14, weight: .semibold))
                            Text("Modify")
                                .font(.headline)
                        }
                        .foregroundColor(.button)
                    }
                )
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
            TabView(selection: $selection) {
                ForEach(0..<frequencyTypeToInt(), id: \.self) { index in
                    let dayDate = dateForPage(index)
                    let dailyRecord = exercisesFor(date: dateForPage(index))

                    ScrollView {
                        DailyPlanCardComponent(
                            date: dayDate,
                            records: dailyRecord,
                            isCurrentDay: isToday(dayDate),
                            onStart: { record in selectedRecord = record }
                        )
                        .padding(.horizontal)
                        .tag(index)
                    }
                    .onAppear {
                        viewModel.setCurrentRecords(
                            date: dayDate,
                            records: dailyRecord
                        )
                    }
                    .onChange(of: viewModel.currentWeek?.records) {
                        viewModel.setCurrentRecords(
                            date: dayDate,
                            records: dailyRecord
                        )
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .sheet(item: $selectedRecord) { record in
                //                RecordView(record: record, modelContext: modelContext)
            }
        }
    }
}

#Preview {
    WeeklyPlanComponent().environment(ExerciseViewModel())
}
