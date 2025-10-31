//
//  RecommendationViewMode+Compute.swift
//  lastbite-exercise
//
//  Created by Niken Larasati on 31/10/25.
//

import Foundation

extension RecommendationViewModel {
    
    /// PURE FUNCTION: Menghitung total menit dasar berdasarkan nomor minggu
    static func computeBaseMinutes(for weekNumber: Int?) -> Int {
        switch weekNumber {
        case 1:  return 30
        case 2:  return 36
        case 3:  return 45
        case 4:  return 60
        case 5:  return 100
        case 6:  return 120
        default: return 150
        }
    }
    
    /// PURE FUNCTION: Menghitung durasi per latihan
    static func computeMinutesPerSession(
        from frequency: FrequencyType,
        baseMinutes: Int
    ) -> Int {
        switch frequency {
        case .oneDay:    return baseMinutes / 1
        case .twoDays:   return baseMinutes / 2
        case .threeDays: return baseMinutes / 3
        case .fourDays:  return baseMinutes / 4
        case .fiveDays:  return baseMinutes / 5
        }
    }
}
