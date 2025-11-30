//
//  HistoryCardComponent.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

import SwiftUI

struct HistoryCardComponent: View {
    let item: HistoryItem
    let onSelect: (HistoryItem) -> Void

    var body: some View {
        Button {
            onSelect(item)
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                let totalRecorded = item.entries.reduce(0) {
                    $0 + $1.recordedSeconds
                }
                let totalRequired = item.entries.reduce(0) {
                    $0 + $1.requiredSeconds
                }

                Text(
                    "\(totalRecorded.getMinutes())/\(totalRequired.getMinutes()) mins"
                )
                .font(.headline)
                .padding(.top, 8)

                Text(item.date)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.card)
            .cornerRadius(30)
        }
        .buttonStyle(.plain)
    }
}
