//
//  HistoryDetailCard.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 05/11/25.
//

import SwiftUI

struct HistoryDetailCard: View {
    let historyItem: HistoryItem
    let onSetAsPlan: () -> Void

    var totalTime: String {
        "\(historyItem.minutes) mins"
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
                                    Text(entry.name)
                                        .font(.headline)
                                    Spacer()
                                    Text(
                                        "\(entry.doneMinutes)/\(entry.targetMinutes) mins"
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
                    Button(action: onSetAsPlan) {
                        Text("Set as today's plan")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .frame(width: geometry.size.width * 0.5)
                            .background(Color("Blue2"))
                            .cornerRadius(50)
                            .position(x: geometry.size.width / 2, y: 30)
                    }
                }
            }
            .padding()
            .navigationTitle(
                historyItem.date.formatted(
                    .dateTime.weekday(.wide).day().month(.wide).year()
                )
            )
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(edges: .bottom)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark") {
                        dismiss()
                    }
                }
            }
        }
    }
}
