//
//  HistoryView.swift
//  Exa
//
//  Created by Niken Larasati on 28/10/25.
//

import SwiftUI
import SwiftData

struct HistoryItem: Identifiable {
    let id = UUID()
    let date: String
    let entries: [ExerciseRecord]
}

struct RecentHistoryView: View {
    @Environment(RecommendationViewModel.self) private var viewModel
    @Environment(\.modelContext) private var modelContext
    @State private var selectedItem: HistoryItem? = nil
    
    @Query(
        filter: #Predicate<ExerciseRecord> { $0.isCompleted == true },
        sort: \ExerciseRecord.completedAt,
        order: .reverse
    ) private var completedExercises: [ExerciseRecord]
    
    @State private var debugPressCount = 0
    
    var groupedHistory: [String: [ExerciseRecord]] {
        Dictionary(grouping: completedExercises, by: {
            $0.completedAt?.formatted(.dateTime.weekday(.wide).day().month(.wide).year()) ?? "Unknown"
        })
    }
    
    var sortedHistoryItems: [HistoryItem] {
        let mappedItems = groupedHistory.map { (dateString, records) -> HistoryItem in
            return HistoryItem(date: dateString, entries: records)
        }
        
        let sortedItems = mappedItems.sorted {
            let date1 = $0.entries.first?.completedAt ?? Date.distantPast
            let date2 = $1.entries.first?.completedAt ?? Date.distantPast
            
            return date1 > date2
        }
        
        return sortedItems
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent History")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color("Blue2"))
                .onTapGesture {
#if DEBUG
                    debugPressCount += 1
                    let targetDate = Calendar.current.date(byAdding: .day, value: -debugPressCount, to: Date()) ?? Date()
                    
                    let allExercises = Exercise.loadExercises()
                    guard allExercises.count > 5 else {
                        print("DEBUG: Exercise.loadExercises() tidak punya cukup data (butuh > 5).")
                        return
                    }
                    
                    let exercise1 = allExercises[1]
                    let exercise2 = allExercises[5]
                    
                    let record1 = ExerciseRecord(exercise: exercise1, requiredMinutes: 10)
                    let record2 = ExerciseRecord(exercise: exercise2, requiredMinutes: 5)
                    
                    record1.isCompleted = true
                    record1.recordedMinutes = 8
                    record1.completedAt = targetDate
                    
                    record2.isCompleted = true
                    record2.recordedMinutes = 5
                    record2.completedAt = targetDate
                    
                    modelContext.insert(record1)
                    modelContext.insert(record2)
                    
                    print("DEBUG: 2 record palsu berhasil dibuat untuk \(debugPressCount) hari yang lalu.")
#endif
                }
            
            VStack(spacing: 12) {
                ForEach(sortedHistoryItems) { item in
                    Button {
                        selectedItem = item
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            let totalRecorded = item.entries.reduce(0) { $0 + $1.recordedMinutes }
                            let totalRequired = item.entries.reduce(0) { $0 + $1.requiredMinutes }
                            
                            Text("\(totalRecorded)/\(totalRequired) mins")
                                .font(.headline)
                                .padding(.top, 8)
                            
                            Text(item.date)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
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
                
                viewModel.modifyExerciseRecords(
                    records: item.entries
                )
                
                selectedItem = nil
            }
            .presentationDetents([.fraction(0.5)])
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
                                    Text(entry.exercise?.name ?? "Unnamed Exercise")
                                        .font(.headline)
                                    Spacer()
                                    Text("\(entry.recordedMinutes)/\(entry.requiredMinutes) mins")
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

#Preview{
    RecentHistoryView()
}
