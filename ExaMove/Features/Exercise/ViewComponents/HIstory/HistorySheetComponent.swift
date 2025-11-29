//
//  HistoryDetailView.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 05/11/25.
//

import SwiftUI

struct HistorySheetComponent: View {
    let historyItem: HistoryItem
    let onSetAsPlan: () -> Void

    var totalTime: String {
        let total = historyItem.entries.reduce(0) { $0 + $1.recordedSeconds }

        return "\(total.getMinutes()) mins"
    }

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack {
                    Text("Total Time: \(totalTime)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.top, 10)

                    VStack(spacing: 0) {
                        ForEach(historyItem.entries) { entry in
                            VStack {
                                HStack {
                                    Text(
                                        entry.exercise?.name
                                            ?? "Unnamed Exercise"
                                    )
                                    .font(.headline)
                                    Spacer()
                                    Text(
                                        "\(entry.recordedSeconds.getMinutes())/\(entry.requiredSeconds.getMinutes()) mins"
                                    )
                                    .font(.headline)
                                }
                            }
                            .padding(10)
                            .padding(.bottom, 16)

                            if entry.id != historyItem.entries.last?.id {
                                Divider()
                            }
                        }
                    }
                }
                .background(Color(.white))
                .cornerRadius(30)

                GeometryReader { geometry in
                    ButtonWSound(action: onSetAsPlan) {
                        Text("Set as today's plan")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .frame(width: geometry.size.width * 0.5)
                            .background(.button)
                            .cornerRadius(50)
                            .position(x: geometry.size.width / 2, y: 30)
                    }
                }
            }
            .padding()
            .navigationTitle(historyItem.date)
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(edges: .bottom)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(
                        action: {
                            dismiss()
                        },
                        label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.secondary)
                        }
                    )
                    .buttonStyle(.borderless)
                }
            }
        }
    }
}
