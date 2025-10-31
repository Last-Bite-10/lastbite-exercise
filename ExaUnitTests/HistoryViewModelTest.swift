//
//  HistoryViewModelTest.swift
//  lastbite-exercise
//
//  Created by Niken Larasati on 31/10/25.
//

import Foundation
import Testing
@testable import Exa

@Suite("HistoryViewModel – Unit (Pure Compute)")
struct HistoryViewModelComputeTests {

    // Helper: Buat objek ExerciseRecord palsu
    // (Kita tidak perlu database SwiftData karena fungsinya murni)
    private func createMockRecord(
        name: String,
        done: Int,
        target: Int,
        date: Date
    ) -> ExerciseRecord {
        let record = ExerciseRecord(
            exerciseName: name,
            exerciseId: 1,
            requiredMinutes: target
        )
        record.recordedMinutes = done
        record.createdAt = date
        record.isCompleted = true
        return record
    }

    // Helper: Buat tanggal relatif
    private func date(daysAgo: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date())!
    }

    @Test("Given 3 record (2 hari ini, 1 kemarin), When compute, Then dikelompokkan jadi 2 HistoryItem")
    func test_computeHistory_groupsRecordsByDay() {
        // GIVEN:
        // 3 data mentah (2 dari "hari ini", 1 dari "kemarin")
        let today = date(daysAgo: 0)
        let yesterday = date(daysAgo: 1)
        
        let records: [ExerciseRecord] = [
            createMockRecord(name: "Walk", done: 20, target: 20, date: today),
            createMockRecord(name: "Squats", done: 10, target: 10, date: today),
            createMockRecord(name: "Run", done: 30, target: 30, date: yesterday)
        ]

        // WHEN:
        // Kita panggil "Otak" (fungsi murni)
        let historyItems = HistoryViewModel.computeHistoryItems(from: records)

        // THEN:
        // Hasilnya harus 2 HistoryItem (karena dikelompokkan per hari)
        #expect(historyItems.count == 2)
        
        // Item pertama (hari ini) harus punya 2 entri
        let todayItem = historyItems[0]
        #expect(todayItem.entries.count == 2)
        #expect(todayItem.minutes == 30) // 20 + 10
        #expect(todayItem.totalMinutes == 30) // 20 + 10

        // Item kedua (kemarin) harus punya 1 entri
        let yesterdayItem = historyItems[1]
        #expect(yesterdayItem.entries.count == 1)
        #expect(yesterdayItem.minutes == 30)
    }
    
    @Test("Given data mentah tidak terurut, When compute, Then hasil akhir terurut (terbaru dulu)")
    func test_computeHistory_sortsResultByDate() {
        // GIVEN:
        // Data mentah kita tidak terurut (kemarin, 3 hari lalu, hari ini)
        let today = date(daysAgo: 0)
        let yesterday = date(daysAgo: 1)
        let threeDaysAgo = date(daysAgo: 3)

        let records: [ExerciseRecord] = [
            createMockRecord(name: "Run", done: 30, target: 30, date: yesterday),
            createMockRecord(name: "Yoga", done: 15, target: 15, date: threeDaysAgo),
            createMockRecord(name: "Walk", done: 20, target: 20, date: today)
        ]

        // WHEN:
        let historyItems = HistoryViewModel.computeHistoryItems(from: records)

        // THEN:
        // Hasil akhir 'historyItems' harus terurut (today -> yesterday -> 3 days ago)
        #expect(historyItems.count == 3)
        #expect(historyItems[0].minutes == 20) // Data hari ini
        #expect(historyItems[1].minutes == 30) // Data kemarin
        #expect(historyItems[2].minutes == 15) // Data 3 hari lalu
    }
    
    @Test("Given tidak ada data (Edge Case), When compute, Then hasil kosong")
    func test_computeHistory_withEmptyData_returnsEmptyArray() {
        // GIVEN:
        let records: [ExerciseRecord] = []

        // WHEN:
        let historyItems = HistoryViewModel.computeHistoryItems(from: records)

        // THEN:
        #expect(historyItems.isEmpty == true)
    }
}
