//
//  RecordView.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 30/11/25.
//

import SwiftUI

struct RecordView: View {
    @Environment(RecordViewModel.self) private var viewModel
    @Environment(\.modelContext) private var modelContext

    let record: ExerciseRecord

    var body: some View {
        Group {
            if viewModel.record != record {
                ProgressView().onAppear {
                    viewModel.setup(modelContext, for: record)
                }
            } else {
                RecordViewComponent(record: record)
                    .environment(viewModel)
            }
        }
    }
}
