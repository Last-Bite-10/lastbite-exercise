//
//  HistoryViewModel+Compute.swift
//  Exa
//
//  Created by Niken Larasati on 31/10/25.
//
import Foundation
import SwiftData

// Struktur data dipindahkan ke sini agar bisa diakses oleh 'compute'
struct ExerciseEntry: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let doneMinutes: Int
    let targetMinutes: Int
}

struct HistoryItem: Identifiable, Hashable {
    let id = UUID()
    let minutes: Int
    let totalMinutes: Int
    let date: Date
    let entries: [ExerciseEntry]
}

extension HistoryViewModel {
    
    /// PURE FUNCTION: Mengubah data mentah [ExerciseRecord] menjadi [HistoryItem]
    /// yang dikelompokkan berdasarkan hari.
    static func computeHistoryItems(
        from records: [ExerciseRecord]
    ) -> [HistoryItem] {
        
        // 1. Gunakan Dictionary untuk mengelompokkan record berdasarkan hari
        //    (Kita normalisasi tanggalnya agar jam/menit/detik diabaikan)
        let calendar = Calendar.current
        let recordsByDay = Dictionary(grouping: records) { (record) -> Date in
            return calendar.startOfDay(for: record.createdAt)
        }

        // 2. Ubah Dictionary [Date: [Record]] menjadi [HistoryItem]
        let historyItems: [HistoryItem] = recordsByDay.map { (date, recordsOnThisDay) in
            
            // 3. Ubah [ExerciseRecord] menjadi [ExerciseEntry]
            let entries = recordsOnThisDay.map { record -> ExerciseEntry in
                return ExerciseEntry(
                    name: record.exerciseName,
                    doneMinutes: record.recordedMinutes,
                    targetMinutes: record.requiredMinutes
                )
            }
            
            // 4. Hitung total untuk 'HistoryItem'
            let totalDone = entries.reduce(0) { $0 + $1.doneMinutes }
            let totalTarget = entries.reduce(0) { $0 + $1.targetMinutes }
            
            return HistoryItem(
                minutes: totalDone,
                totalMinutes: totalTarget,
                date: date,
                entries: entries
            )
        }
        
        // 5. Urutkan hasilnya dari yang terbaru (tanggal terbesar) ke terlama
        return historyItems.sorted { $0.date > $1.date }
    }
}
