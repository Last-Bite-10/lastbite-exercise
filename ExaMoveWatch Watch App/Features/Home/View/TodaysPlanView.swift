//
//  TodayPlanView.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 07/11/25.
//

import SwiftData
import SwiftUI

struct TodaysPlanView: View {
    @State private var viewModel: RecordViewModel

    @Query private var records: [ExerciseRecord]

    var todaysRecords: [ExerciseRecord] {
        records.filter {
            Calendar.current.isDateInToday($0.usedAt)
        }
    }

    init() {
        _viewModel = .init(
            initialValue: .init(
                healthKitService: HealthKitService(),
                connectivityService: WCService()
            )
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Plan")
                .font(.title3)
                .bold()

            ForEach(todaysRecords) { record in
                ExerciseRowComponent(record: record) {
                    viewModel.sendSelectedRecord(record)
                }
                .environment(viewModel)
            }
        }
        .padding()
    }
}

#Preview {
    TodaysPlanView()
}
