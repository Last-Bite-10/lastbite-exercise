//
//  HistoryViewModel.swift
//  lastbite-exercise
//
//  Created by Niken Larasati on 31/10/25.
//

import Foundation
import SwiftUI

// MARK: - Data Structures
// Struct ini dipindahkan dari View ke sini

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

// MARK: - History View Model

@Observable
class HistoryViewModel {
    
    // Properti yang dipindahkan dari MyExerciseView
    var historyItems: [HistoryItem] = []

    init() {
        // Logika untuk memuat data (sebelumnya @State) sekarang ada di sini
        loadHistory()
    }
    
    // Di masa depan, fungsi ini dapat mengambil data dari ModelContext
    func loadHistory() {
        // Data hardcoded dipindahkan ke sini
        self.historyItems = [
            HistoryItem(
                minutes: 25,
                totalMinutes: 30,
                date: Calendar.current.date(byAdding: .day, value: -9, to: Date())!,
                entries: [
                    ExerciseEntry(name: "Brisk Walk", doneMinutes: 20, targetMinutes: 20),
                    ExerciseEntry(name: "Squats", doneMinutes: 10, targetMinutes: 10)
                ]
            ),
            HistoryItem(
                minutes: 25,
                totalMinutes: 30,
                date: Calendar.current.date(byAdding: .day, value: -9, to: Date())!,
                entries: [
                    ExerciseEntry(name: "Brisk Walk", doneMinutes: 20, targetMinutes: 20),
                    ExerciseEntry(name: "Squats", doneMinutes: 10, targetMinutes: 10)
                ]
            ),
            HistoryItem(
                minutes: 25,
                totalMinutes: 30,
                date: Calendar.current.date(byAdding: .day, value: -9, to: Date())!,
                entries: [
                    ExerciseEntry(name: "Brisk Walk", doneMinutes: 20, targetMinutes: 20),
                    ExerciseEntry(name: "Squats", doneMinutes: 10, targetMinutes: 10)
                ]
            ),
            HistoryItem(
                minutes: 25,
                totalMinutes: 30,
                date: Calendar.current.date(byAdding: .day, value: -9, to: Date())!,
                entries: [
                    ExerciseEntry(name: "Brisk Walk", doneMinutes: 20, targetMinutes: 20),
                    ExerciseEntry(name: "Squats", doneMinutes: 10, targetMinutes: 10)
                ]
            )
        ]
    }
}
