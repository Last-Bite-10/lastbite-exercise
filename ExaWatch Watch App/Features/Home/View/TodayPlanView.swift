//
//  TodayPlanView.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 07/11/25.
//

import SwiftData
import SwiftUI

struct TodayPlanView: View {
    @StateObject private var healthManager = WatchHealthManager.shared
    @Query(
        filter: #Predicate<ExerciseRecord> { record in
            record.isCompleted == false
        }
    ) private var records: [ExerciseRecord]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("Today's Plan")
                .font(.title3)
                .bold()

            ForEach(records, id: \.id) { record in
                ExerciseRow(
                    name: record.exercise!.name,
                    duration: record.requiredSeconds / 60
                ) {
                    healthManager.sendExerciseStart(
                        exerciseId: record.id.uuidString
                    )
                }
            }

        }
        .padding()
    }
}

#Preview {
    TodayPlanView()
}
