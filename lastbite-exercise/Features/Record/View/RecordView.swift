//
//  HealthKitView.swift (RecordView.swift)
//  Exa
//
//  Created by Ammar Alifian Fahdan on 20/10/25.
//

import SwiftUI
import HealthKit
import Combine
import SwiftData // DITAMBAHKAN

// func formatTime(duration: Int) -> String {
//     return "\(String(format: "%02d", duration / 60)):\(String(format: "%02d", duration % 60))"
// }

enum TimerStatus {
    case timerPaused
    case timerStarted
    case timerStopped
    case timerOverflown
}

struct RecordView: View {
    @StateObject private var healthKitManager: HealthKitManager // DIUBAH: Dihapus inisialisasi default
    @StateObject private var viewModel: RecordViewModel
    
    // DIUBAH: init() sekarang menerima semua parameter yang diperlukan
    init(
        totalTime: Int,
        exerciseId: Int,
        exerciseName: String,
        week: Weekly?,
        modelContext: ModelContext // DITAMBAHKAN
    ) {
        let manager = HealthKitManager()
        _healthKitManager = StateObject(wrappedValue: manager)
        
        // DIUBAH: Melewatkan semua parameter ke viewModel
        _viewModel = StateObject(wrappedValue: RecordViewModel(
            totalTime: totalTime,
            exerciseId: exerciseId,
            exerciseName: exerciseName,
            week: week,
            healthKitManager: manager,
            modelContext: modelContext
        ))
    }

    var body: some View {
        VStack {
            ZStack {
                // Background circle
                Circle()
                    .stroke(
                        !viewModel.isPaused
                        ? Color.accentColor.opacity(0.2)
                        : Color.gray2.opacity(1),
                        lineWidth: 30
                    )

                // Progress circle
                Circle()
                    .trim(from: 0, to: viewModel.progress)
                    .stroke(
                        !viewModel.isPaused
                        ? Color.blue2
                        : Color.gray3,
                        style: StrokeStyle(lineWidth: 30, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: viewModel.progress)

                VStack {
                    VStack {
                        Text("Active Time")
                        Text(viewModel.activeTimeFormatted)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }.padding(.bottom, 12)

                    VStack {
                        Text("BPM")

                        if let bpm = viewModel.currentBPM {
                            Text("\(bpm)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(
                                    viewModel.isBPMUnder ? Color.red : Color.black
                                )
                        } else {
                            Text("--")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                         
                        if viewModel.isReceivingFromWatch {
                            Image(systemName: "applewatch")
                                .foregroundStyle(.blue)
                                .font(.caption)
                        }
                    }
                }
            }
            .frame(width: 260, height: 260)

            VStack {
                Text("Total Time").font(.title2).padding(.bottom, 4)

                Text(viewModel.totalTimeFormatted).font(.title).fontWeight(.bold)
            }
            .padding(.vertical, 36)

            VStack {
                RecordPlayButton(title: viewModel.isPaused ? "Start" : "Pause") {
                    viewModel.togglePause()
                }

                Button("End") {
                    viewModel.finishExercise()
                }
            }
        }
        .onAppear {
            viewModel.startMonitoring()
        }
        .onDisappear {
            viewModel.stopMonitoring()
        }
    }
}

// DIUBAH: Preview diperbarui agar menyertakan SwiftData ModelContainer
#Preview {
    do {
        // 1. Buat ModelContainer in-memory
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Weekly.self, ExerciseRecord.self, configurations: config)
        
        // 2. Buat data palsu (mock)
        let week = Weekly(weekNumber: 1, startDate: Date())
        container.mainContext.insert(week)
        
        // 3. Injeksi container dan context ke View
        return RecordView(
            totalTime: 100,
            exerciseId: 1,
            exerciseName: "Preview Exercise",
            week: week,
            modelContext: container.mainContext
        )
        .modelContainer(container)
        
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
