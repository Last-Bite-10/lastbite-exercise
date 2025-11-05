//
//  HistoryView.swift
//  lastbite-exercise
//
//  Created by Niken Larasati on 23/10/25.
//

import SwiftUI

struct ExerciseEntry: Identifiable {
    let id = UUID()
    let name: String
    let doneMinutes: Int
    let targetMinutes: Int
}

struct HistoryItem: Identifiable {
    let id = UUID()
    let minutes: Int
    let totalMinutes: Int
    let date: Date
    let entries: [ExerciseEntry]
}

struct RecentHistoryView: View {
    let historyItems: [HistoryItem]
    @State private var selectedItem: HistoryItem?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent History")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.blueTwo)

            VStack(spacing: 12) {
                ForEach(historyItems) { item in
                    Button {
                        selectedItem = item
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(item.minutes)/\(item.totalMinutes) mins")
                                .font(.headline)
                                .padding(.top, 8)

                            Text(
                                item.date,
                                format: .dateTime.weekday().day().month().year()
                            )
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.bottom, 8)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.cardGray)
                        .cornerRadius(30)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding()
        .sheet(item: $selectedItem) { item in
            HistoryDetailCard(historyItem: item) {

                // action when "Set as today's plan" pushed

                print("Set as today's plan for \(item.date)")

                selectedItem = nil
            }
            .presentationDetents([.fraction(0.4)])
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    RecentHistoryView(historyItems: [
        HistoryItem(
            minutes: 30,
            totalMinutes: 30,
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            entries: [
                ExerciseEntry(
                    name: "Brisk Walk",
                    doneMinutes: 20,
                    targetMinutes: 20
                ),
                ExerciseEntry(
                    name: "Squats",
                    doneMinutes: 10,
                    targetMinutes: 10
                ),
            ]
        ),
        HistoryItem(
            minutes: 35,
            totalMinutes: 30,
            date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            entries: [
                ExerciseEntry(
                    name: "Brisk Walk",
                    doneMinutes: 20,
                    targetMinutes: 20
                ),
                ExerciseEntry(
                    name: "Squats",
                    doneMinutes: 10,
                    targetMinutes: 10
                ),
            ]
        ),
    ])
}
