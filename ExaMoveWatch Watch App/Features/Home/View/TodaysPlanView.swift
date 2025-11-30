//
//  TodayPlanView.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 07/11/25.
//

import SwiftData
import SwiftUI

struct TodaysPlanView: View {
    @Environment(\.modelContext) private var modelContext

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
                ExerciseRowComponent(record: record)
                    .environment(viewModel)
            }
        }
        .padding()
        .onReceive(
            NotificationCenter.default.publisher(
                for: .receiveRecordTimerStatusUpdate
            ),
            perform: { notification in
                if let message = notification.object as? [String: Any],
                    let statusString = message["status"] as? String,
                    let status = TimerStatus(rawValue: statusString),
                    let recordIdString = message["recordId"] as? String,
                    let record = todaysRecords.first(where: {
                        $0.id.uuidString == recordIdString
                    })
                {
                    Debugging.debug(
                        "Setting up view model for selected record successfully: \(record.id)"
                    )
                    viewModel.setup(modelContext, for: record)
                    switch status {
                    case .timerStarted:
                        viewModel.startRecordTimer(send: false)
                    case .timerPaused:
                        viewModel.pauseRecordTimer(send: false)
                    case .timerStopped:
                        viewModel.endRecordTimer(send: false)
                    default:
                        viewModel.timerService?.handleTimerStatusChange(status)
                    }
                }
            }
        )
    }
}

#Preview {
    TodaysPlanView()
}
