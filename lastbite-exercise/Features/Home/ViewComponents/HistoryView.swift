//
//  HistoryView.swift
//  lastbite-exercise
//
//  Created by Niken Larasati on 23/10/25.
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
                                    Text("\(entry.doneMinutes)/\(entry.targetMinutes) mins")
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
            .navigationTitle(historyItem.date.formatted(.dateTime.weekday(.wide).day().month(.wide).year()))
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

#Preview {
    RecentHistoryView(historyItems:
    [HistoryItem(
        minutes: 30,
        totalMinutes: 30,
        date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
        entries: [
            ExerciseEntry(name: "Brisk Walk", doneMinutes: 20, targetMinutes: 20),
            ExerciseEntry(name: "Squats", doneMinutes: 10, targetMinutes: 10)
        ]
    ),
    HistoryItem(
        minutes: 35,
        totalMinutes: 30,
        date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
        entries: [
            ExerciseEntry(name: "Brisk Walk", doneMinutes: 20, targetMinutes: 20),
            ExerciseEntry(name: "Squats", doneMinutes: 10, targetMinutes: 10)
        ]
    )
    ])
}
