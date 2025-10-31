//
//  StreakViewModel+Compute.swift
//  lastbite-exercise
//
//  Created by Niken Larasati on 31/10/25.
//

// StreakViewModel+Compute.swift (di target app, bukan test)
import Foundation

extension StreakViewModel {
    /// PURE FUNCTION: hitung deretan `StreakWeek` dari total menit per minggu
    /// - Parameter minutesByWeekDesc: Week 1 = elemen 0 (terbaru), dst.
    static func computeWeeklyStreaks(
        minutesByWeekDesc: [Int],
        maxWeeksToShow: Int,
        thresholdMinutes: Int
    ) -> [StreakWeek] {
        var results: [StreakWeek] = []
        results.reserveCapacity(maxWeeksToShow)

        var streakBroken = false
        var hasStarted   = false

        let availableWeeks = Array(minutesByWeekDesc.prefix(maxWeeksToShow))

        for (index, minutesThisWeek) in availableWeeks.enumerated() {
            let weekDisplayNumber = index + 1

            if index == 0 {
                if minutesThisWeek >= thresholdMinutes {
                    hasStarted = true
                    results.append(StreakWeek(weekNumber: weekDisplayNumber, status: .achieved))
                } else {
                    results.append(StreakWeek(weekNumber: weekDisplayNumber, status: .missed))
                }
                continue
            }

            if !hasStarted {
                results.append(StreakWeek(weekNumber: weekDisplayNumber, status: .locked))
                continue
            }

            if streakBroken {
                if minutesThisWeek >= thresholdMinutes {
                    results.append(StreakWeek(weekNumber: weekDisplayNumber, status: .achieved))
                    streakBroken = false
                } else {
                    results.append(StreakWeek(weekNumber: weekDisplayNumber, status: .missed))
                }
                continue
            }

            if minutesThisWeek >= thresholdMinutes {
                results.append(StreakWeek(weekNumber: weekDisplayNumber, status: .achieved))
            } else {
                results.append(StreakWeek(weekNumber: weekDisplayNumber, status: .missed))
                streakBroken = true
            }
        }

        if results.count < maxWeeksToShow {
            for placeholderIndex in results.count..<maxWeeksToShow {
                results.append(
                    StreakWeek(weekNumber: placeholderIndex + 1, status: .locked)
                )
            }
        }
        return results
    }
}

// Opsional untuk memudahkan test terintegrasi ringan
extension StreakViewModel {
    func loadStreaksFromMinutes(
        minutesByWeekDesc: [Int],
        maxWeeksToShow: Int = 6,
        thresholdMinutes: Int = 150
    ) {
        self.weeklyStreaks = Self.computeWeeklyStreaks(
            minutesByWeekDesc: minutesByWeekDesc,
            maxWeeksToShow: maxWeeksToShow,
            thresholdMinutes: thresholdMinutes
        )
    }
}

