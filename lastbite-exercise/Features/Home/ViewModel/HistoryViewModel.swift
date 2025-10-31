//
//  HistoryViewModel.swift
//  Exa
//
//  Created by Niken Larasati on 31/10/25.
//

import Foundation
import SwiftData
import Observation

@Observable
class HistoryViewModel {
    
    var historyItems: [HistoryItem] = []
    
    // Hapus data hardcoded dan 'init()'

    // Fungsi 'setup' ini dipanggil oleh View
    func setup(modelContext: ModelContext) {
        fetchHistory(modelContext: modelContext)
    }
    
    /// "Kaki Tangan": Tugasnya hanya I/O (Fetch) dan mendelegasikan ke "Otak" (Compute)
    func fetchHistory(modelContext: ModelContext) {
        // 1. Ambil SEMUA ExerciseRecord yang sudah selesai
        let descriptor = FetchDescriptor<ExerciseRecord>(
            predicate: #Predicate { $0.isCompleted == true },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        
        let records: [ExerciseRecord]
        do {
            records = try modelContext.fetch(descriptor)
        } catch {
            print("Gagal fetch ExerciseRecord: \(error)")
            self.historyItems = []
            return
        }
        
        // 2. Panggil "Otak" (Pure Function) untuk melakukan logika berat
        self.historyItems = Self.computeHistoryItems(from: records)
    }
}
