//
//  StreakViewModelTest.swift
//  lastbite-exercise
//
//  Created by Niken Larasati on 31/10/25.
//

import Testing
@testable import Exa

@Suite("StreakViewModel – Unit (Pure Compute)")
struct StreakComputeTests {

    // Helper ringkas
    private func statuses(_ weeks: [StreakWeek]) -> [StreakStatus] { weeks.map(\.status) }

    // MARK: - Happy path beruntun
    @Test("Given >= threshold terus, When compute, Then semua achieved dan sisanya locked")
    func allAchieved_thenPadLocked() {
        // Given
        let minutes = [200, 180, 151] // 3 minggu data
        // When
        let out = StreakViewModel.computeWeeklyStreaks(
            minutesByWeekDesc: minutes,
            maxWeeksToShow: 6,
            thresholdMinutes: 150
        )
        // Then
        #expect(out.count == 6)
        #expect(statuses(out) == [.achieved, .achieved, .achieved, .locked, .locked, .locked])
        #expect(out[0].weekNumber == 1 && out[5].weekNumber == 6)
    }

    // MARK: - Belum mulai (week1 < threshold)
    @Test("Given week1 < threshold, When compute, Then week1 missed & berikutnya locked")
    func notStarted_firstWeekBelowThreshold() {
        // Given
        let minutes = [120, 300, 300, 300]
        // When
        let out = StreakViewModel.computeWeeklyStreaks(
            minutesByWeekDesc: minutes,
            maxWeeksToShow: 5,
            thresholdMinutes: 150
        )
        // Then
        #expect(statuses(out) == [.missed, .locked, .locked, .locked, .locked])
    }

    // MARK: - Putus setelah berjalan
    @Test("Given berjalan lalu miss, When compute, Then miss menandai putus")
    func streakBreaks_onFirstMiss() {
        // Given
        let minutes = [200, 200, 100, 200]
        // When
        let out = StreakViewModel.computeWeeklyStreaks(
            minutesByWeekDesc: minutes,
            maxWeeksToShow: 6,
            thresholdMinutes: 150
        )
        // Then
        #expect(statuses(out).prefix(4) == [.achieved, .achieved, .missed, .achieved])
        #expect(statuses(out).suffix(2) == [.locked, .locked])
    }

    // MARK: - Edge: tepat di batas threshold
    @Test("Given tepat = threshold, When compute, Then dianggap achieved")
    func equalsThreshold_isAchieved() {
        // Given
        let minutes = [150, 150, 149]
        // When
        let out = StreakViewModel.computeWeeklyStreaks(
            minutesByWeekDesc: minutes,
            maxWeeksToShow: 4,
            thresholdMinutes: 150
        )
        // Then
        #expect(statuses(out) == [.achieved, .achieved, .missed, .locked])
    }

    // MARK: - Edge: kosong
    @Test("Given tidak ada data, When compute, Then semua locked")
    func emptyData_allLocked() {
        // Given
        let minutes: [Int] = []
        // When
        let out = StreakViewModel.computeWeeklyStreaks(
            minutesByWeekDesc: minutes,
            maxWeeksToShow: 3,
            thresholdMinutes: 150
        )
        // Then
        #expect(statuses(out) == [.locked, .locked, .locked])
    }

    // MARK: - Parameterized: putus & muncul lagi
    @Test("Given variasi data, When compute, Then konsisten sesuai aturan putus & muncul lagi")
    func variations_loop() {
      let cases: [([Int], [StreakStatus])] = [
        ([200, 99, 99, 200, 200],  [.achieved, .missed, .missed, .achieved, .achieved, .locked]),
        ([200, 200, 99, 99],       [.achieved, .achieved, .missed, .missed, .locked, .locked]),
      ]
      for (input, expected) in cases {
        let out = StreakViewModel.computeWeeklyStreaks(
          minutesByWeekDesc: input,
          maxWeeksToShow: 6,
          thresholdMinutes: 150
        )
        #expect(out.map(\.status) == expected)
      }
    }
}
