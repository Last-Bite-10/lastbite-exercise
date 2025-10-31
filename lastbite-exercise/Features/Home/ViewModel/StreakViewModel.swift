//
//  StreakViewModel.swift
//  lastbite-exercise
//
//  Created by Niken Larasati on 31/10/25.
//

import Foundation
import SwiftData
import Observation

/// Status untuk satu minggu streak
enum StreakStatus: Hashable {
    case achieved   // window 7 hari >= 150 menit
    case missed     // putus/placeholder abu-abu
    case locked     // slot di masa depan (belum ada datanya)
}

/// Model data untuk merepresentasikan satu minggu di UI Streak.
struct StreakWeek: Identifiable, Hashable {
    let id = UUID()
    let weekNumber: Int
    let status: StreakStatus
}

@Observable
class StreakViewModel {

    /// Deretan minggu untuk ditampilkan di UI (week 1, 2, 3, dst)
    var weeklyStreaks: [StreakWeek] = []

    init() { }

    /// Hitung status streak berbasis entitas Weekly:
    /// - Week 1 = Weekly terbaru (anggap 7 hari terakhir).
    /// - Week berikutnya = Weekly sebelumnya secara berurutan.
    /// - Jika ada minggu <150 → tandai missed (abu-abu) dan anggap "putus".
    /// - Setelah missed, kalau ada minggu >=150 → "muncul lagi" (achieved).
    ///
    /// Catatan:
    /// - Kita TIDAK memakai `ExerciseRecord.date` (karena tidak ada).
    /// - Total menit dihitung dari penjumlahan `recordedMinutes` di setiap Weekly.
    func loadStreaks(
        modelContext: ModelContext,
        maxWeeksToShow: Int = 6,
        thresholdMinutes: Int = 150
    ) {
        // Ambil Weekly dan urutkan dari yang TERBARU ke TERLAMA,
        // supaya elemen pertama = week 1 (7 hari terakhir versi data kamu).
        // Jika `weekNumber` kamu naik seiring waktu, pakai descending.
        let descriptor = FetchDescriptor<Weekly>(sortBy: [SortDescriptor(\.weekNumber, order: .reverse)])

        let weeklyEntities: [Weekly]
        do {
            weeklyEntities = try modelContext.fetch(descriptor)
        } catch {
            print("Gagal mengambil Weekly: \(error.localizedDescription)")
            self.weeklyStreaks = []
            return
        }

        // Ambil hanya sebanyak yang ingin ditampilkan (atau semua jika lebih sedikit).
        let availableWeeks = Array(weeklyEntities.prefix(maxWeeksToShow))

        // Helper: total menit per Weekly (tanpa akses tanggal).
        func totalMinutes(for weekly: Weekly) -> Int {
            return weekly.records.reduce(0) { partial, record in
                partial + record.recordedMinutes
            }
        }

        var results: [StreakWeek] = []
        results.reserveCapacity(maxWeeksToShow)

        var streakBroken = false   // sudah pernah putus?
        var hasStarted   = false   // week 1 sudah >= threshold?

        // Iterasi untuk data yang tersedia
        for (index, weekly) in availableWeeks.enumerated() {
            let weekDisplayNumber = index + 1
            let minutesThisWeek = totalMinutes(for: weekly)

            if index == 0 {
                // WEEK 1 (weekly terbaru)
                if minutesThisWeek >= thresholdMinutes {
                    hasStarted = true
                    results.append(StreakWeek(weekNumber: weekDisplayNumber, status: .achieved))
                } else {
                    // Belum mulai streak: tampilkan missed (atau bisa locked jika ingin netral)
                    results.append(StreakWeek(weekNumber: weekDisplayNumber, status: .missed))
                }
                continue
            }

            // WEEK >= 2
            if !hasStarted {
                // Streak belum mulai → minggu berikutnya locked (belum ada “rantai” yang dimulai)
                results.append(StreakWeek(weekNumber: weekDisplayNumber, status: .locked))
                continue
            }

            if streakBroken {
                // Setelah putus: slot berikutnya default abu-abu (missed).
                // Jika minggu ini ternyata >= threshold, dianggap "muncul lagi".
                if minutesThisWeek >= thresholdMinutes {
                    results.append(StreakWeek(weekNumber: weekDisplayNumber, status: .achieved))
                    streakBroken = false // lanjut normal lagi
                } else {
                    results.append(StreakWeek(weekNumber: weekDisplayNumber, status: .missed))
                }
                continue
            }

            // Belum pernah putus: nilai normal
            if minutesThisWeek >= thresholdMinutes {
                results.append(StreakWeek(weekNumber: weekDisplayNumber, status: .achieved))
            } else {
                results.append(StreakWeek(weekNumber: weekDisplayNumber, status: .missed))
                streakBroken = true
            }
        }

        // Jika data Weekly lebih sedikit dari slot tampilan, sisanya = locked (masa depan)
        if results.count < maxWeeksToShow {
            for placeholderIndex in results.count..<maxWeeksToShow {
                results.append(StreakWeek(weekNumber: placeholderIndex + 1, status: .locked))
            }
        }

        self.weeklyStreaks = results
    }
}
