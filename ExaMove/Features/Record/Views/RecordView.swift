//
//  RecordTimerView.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

import SwiftUI

struct RecordView: View {
    @Environment(RecordViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss

    var timerMessage: LocalizedStringKey {
        switch viewModel.timerService?.timerStatus ?? .timerStopped {
        case .timerPaused:
            return "The time is paused. Continue by increasing your BPM!"
        case .timerStarted:
            return
                "Your exercise is in progress, your heartbeat is being recorded!"
        case .timerStopped:
            return
                "Start now! Remember only your active time **(BPM >= \(viewModel.bpmTreshold))** will be recorded."
        case .timerOverflown:
            return
                "Your exercise is in progress, your heartbeat is being recorded!"
        case .timerBelowBPM:
            return "The time is paused. Continue by increasing your BPM!"
        }
    }

    var body: some View {
        VStack {
            Text(timerMessage)
                .frame(
                    width: 300,
                    alignment: .center
                )
                .multilineTextAlignment(.center)
                .padding(.bottom, 32)

            RecordTimerComponent().environment(viewModel)

            VStack {
                Text("Total Time").font(.title2).padding(.bottom, 4)

                Text("\(viewModel.totalTimeFormatted)").font(.title).fontWeight(
                    .bold
                )
            }
            .padding(.vertical, 36)

            VStack {
                ButtonWSound(
                    action: {
                        viewModel.timerService?.timerStatus != .timerStarted
                            ? viewModel.startRecordTimer()
                            : viewModel.pauseRecordTimer()
                    },
                    label: {
                        CoreButtonLabel(
                            title: viewModel.timerService?.timerStatus
                                != .timerStarted
                                ? "Start" : "Pause"
                        )
                    }
                )
                .padding(.bottom)

                ButtonWSound(
                    action: {
                        viewModel.endRecordTimer()
                        dismiss()
                    },
                    label: {
                        Text("End").foregroundStyle(.red)
                    }
                )
            }
            .padding(.horizontal, 64)
        }
    }
}

#Preview {
    RecordView().environment(
        RecordViewModel(
            healthKitService: HealthKitService(),
            connectivityService: WCService()
        )
    )
}
