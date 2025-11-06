//
//  HistoryDetailView.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 05/11/25.
//

import SwiftUI

struct RecentHistoryView: View {
    let historyItems: [HistoryItem]
    @State private var selectedItem: HistoryItem? = nil
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent History")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color("Blue2"))
            
            VStack(spacing: 12) {
                ForEach(historyItems) { item in
                    Button {
                        selectedItem = item
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(item.minutes)/\(item.totalMinutes) mins")
                                .font(.headline)
                                .padding(.top, 8)

                            Text(item.date, format: .dateTime.weekday().day().month().year())
                                .font(.subheadline)
                                .foregroundColor(.black)
                                .padding(.bottom, 8)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color("Gray2"))
                        .cornerRadius(30)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding()
        .sheet(item: $selectedItem) { item in
            HistoryDetailView(historyItem: item) {
                
                // action when "Set as today's plan" pushed
                
                print("Set as today's plan for \(item.date)")
                
                selectedItem = nil
            }
            .presentationDetents([.fraction(0.4)])
            .presentationDragIndicator(.visible)
        }
    }
}

struct HistoryDetailView: View {
    let historyItem: HistoryItem
    let onSetAsPlan: () -> Void

    var totalTime: String {
        let total = historyItem.entries.reduce(0) { $0 + $1.recordedMinutes }

        return "\(total) mins"
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
                                        "\(entry.recordedMinutes)/\(entry.requiredMinutes) mins"
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
                            .background(Color.blueTwo)
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
                    Button("Cancel", systemImage: "xmark") {
                        dismiss()
                    }
                }
            }
        }
    }
}
